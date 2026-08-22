variable "hcloud_token" {
  description = "Токен Hetzner Cloud. Передаётся через HCLOUD_TOKEN или -var, но не через tfvars в репозитории"
  type        = string
  sensitive   = true
}

variable "name" {
  description = "Имя машины и префикс остальных ресурсов"
  type        = string
  default     = "qiymet"
}

variable "domain" {
  description = "Домен API. Должен указывать на этот сервер ДО первого старта Caddy: сертификат выпускается по HTTP-01"
  type        = string
}

variable "server_type" {
  description = <<-EOT
    Тип машины. CX22 (2 vCPU, 4 ГБ) — минимум, на котором сходится всё сразу:
    Postgres с shared_buffers 512 МБ, два воркера uvicorn и полный прогон сбора,
    который держит в памяти весь каталог на 36 тысяч товаров.
    На 2 ГБ ночной full упирается в OOM, и убивают обычно Postgres.
  EOT
  type        = string
  default     = "cx22"
}

variable "location" {
  description = "Площадка. nbg1/fsn1 — до Баку ~60 мс, ashburn — 140 и выше"
  type        = string
  default     = "nbg1"
}

variable "volume_size_gb" {
  description = <<-EOT
    Том под данные. 10 ГБ хватает надолго: наблюдений 57 тысяч на прогон,
    пишутся только при изменении цены, а бэкапов держим 30 в custom-формате.
    Минимум у Hetzner всё равно 10.
  EOT
  type        = number
  default     = 10
}

variable "admin_user" {
  description = "Пользователь для ssh. Не root: под ним же работает docker compose"
  type        = string
  default     = "qiymet"
}

variable "ssh_public_key" {
  description = "Открытый ключ для доступа на машину"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Путь к закрытому ключу для remote-exec. Сам ключ в state не попадает"
  type        = string
  default     = "~/.ssh/id_ed25519"
}

variable "ssh_allowed_cidrs" {
  description = <<-EOT
    Откуда пускать по SSH. По умолчанию отовсюду, и это плохой по умолчанию:
    сузь до своего адреса сразу, как только он у тебя постоянный.
  EOT
  type        = list(string)
  default     = ["0.0.0.0/0", "::/0"]
}

variable "repo_url" {
  description = "Откуда клонировать код на машину"
  type        = string
}
