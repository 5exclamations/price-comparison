# Один VPS у Hetzner: машина, диск, файрвол, DNS.
#
# Hetzner, потому что до Баку от их немецких площадок ~60 мс, а CX22 за пять
# евро в месяц тянет всё описанное с запасом. Провайдер меняется в одном
# месте — remote_exec ниже не знает, у кого арендована машина.
#
# Что делает этот модуль и чего НЕ делает:
#
#   делает   — машину, отдельный диск под данные, файрвол, DNS-запись,
#              установку docker, первый разворот compose;
#   не делает — секреты. Пароль базы, токен телеграма и ключ FCM кладутся
#              руками в /srv/qiymet/.env. Класть их в terraform.tfvars значит
#              положить их в state, а state — это файл, который однажды
#              окажется в репозитории.

terraform {
  required_version = ">= 1.6"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.48"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

# ------------------------------------------------------------------ ключ SSH
resource "hcloud_ssh_key" "admin" {
  name       = "${var.name}-admin"
  public_key = var.ssh_public_key
}

# --------------------------------------------------------------------- диск
# Данные на отдельном томе, а не на диске машины.
#
# Так пересоздание сервера перестаёт быть страшным: терраформ убьёт машину,
# том останется, база вместе с ним. На диске самой машины любой `taint`
# уносит всё вместе с историей цен, которую заново не соберёшь — она копится
# только вперёд.
resource "hcloud_volume" "data" {
  name      = "${var.name}-data"
  size      = var.volume_size_gb
  location  = var.location
  format    = "ext4"

  lifecycle {
    prevent_destroy = true
  }
}

# ------------------------------------------------------------------- машина
resource "hcloud_server" "vps" {
  name        = var.name
  image       = "ubuntu-24.04"
  server_type = var.server_type
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.admin.id]

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  user_data = templatefile("${path.module}/cloud-init.yaml", {
    volume_device = hcloud_volume.data.linux_device
    domain        = var.domain
    admin_user    = var.admin_user
    ssh_public_key = var.ssh_public_key
  })

  labels = {
    project = "qiymet"
    role    = "all-in-one"
  }
}

resource "hcloud_volume_attachment" "data" {
  volume_id = hcloud_volume.data.id
  server_id = hcloud_server.vps.id
  automount = false # монтирует cloud-init, ему нужен контроль над fstab
}

# ------------------------------------------------------------------ файрвол
# Внутрь пускаем ровно три порта. Postgres и redis не публикуются вообще —
# ни здесь, ни в docker-compose. Открытый 5432 на публичном IP переживает
# ровно столько, сколько нужно сканеру, чтобы дойти до этой подсети.
resource "hcloud_firewall" "vps" {
  name = "${var.name}-fw"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = var.ssh_allowed_cidrs
    description = "SSH только со своих адресов"
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = ["0.0.0.0/0", "::/0"]
    description = "HTTP: нужен ACME для выпуска сертификата"
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = ["0.0.0.0/0", "::/0"]
    description = "HTTPS"
  }

  rule {
    direction  = "in"
    protocol   = "udp"
    port       = "443"
    source_ips = ["0.0.0.0/0", "::/0"]
    description = "HTTP/3"
  }
}

resource "hcloud_firewall_attachment" "vps" {
  firewall_id = hcloud_firewall.vps.id
  server_ids  = [hcloud_server.vps.id]
}

# ---------------------------------------------------------------------- DNS
# Запись нужна ДО первого старта Caddy: он выпускает сертификат по HTTP-01,
# а для этого домен должен уже указывать сюда. Отсюда зависимость ниже.
resource "hcloud_rdns" "vps_v4" {
  server_id  = hcloud_server.vps.id
  ip_address = hcloud_server.vps.ipv4_address
  dns_ptr    = var.domain
}

# ------------------------------------------------------- первичная настройка
# Разворот вынесен в remote_exec намеренно. Для одной машины ansible — это
# ещё один инструмент, ещё один язык и ещё одна вещь, которую надо помнить
# через полгода. Всё, что делает этот блок, повторяется руками по README.
resource "terraform_data" "bootstrap" {
  depends_on = [
    hcloud_volume_attachment.data,
    hcloud_firewall_attachment.vps,
  ]

  triggers_replace = [
    hcloud_server.vps.id,
    filesha256("${path.module}/cloud-init.yaml"),
  ]

  connection {
    host        = hcloud_server.vps.ipv4_address
    user        = var.admin_user
    private_key = file(var.ssh_private_key_path)
    timeout     = "5m"
  }

  # Ждём, пока cloud-init доедет до конца. Без этого следующая команда
  # прилетает в момент, когда apt ещё держит блокировку, и падает на ровном
  # месте раз через два.
  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait || true",
      "docker --version",
      "test -d /srv/qiymet || sudo git clone ${var.repo_url} /srv/qiymet",
      "sudo chown -R ${var.admin_user}:${var.admin_user} /srv/qiymet",
    ]
  }

  # Секреты сюда не едут. Файл создаётся пустым шаблоном, значения
  # дописываются руками при первом заходе — см. deploy/README.md.
  provisioner "remote-exec" {
    inline = [
      "test -f /srv/qiymet/deploy/.env || cp /srv/qiymet/deploy/.env.example /srv/qiymet/deploy/.env",
      "chmod 600 /srv/qiymet/deploy/.env",
      "echo 'Машина готова. Заполни /srv/qiymet/deploy/.env и запусти deploy/scripts/first-run.sh'",
    ]
  }
}
