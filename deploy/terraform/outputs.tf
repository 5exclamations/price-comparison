output "ipv4" {
  description = "Адрес машины. Эту запись надо прописать в A-запись домена"
  value       = hcloud_server.vps.ipv4_address
}

output "ipv6" {
  value = hcloud_server.vps.ipv6_address
}

output "ssh" {
  description = "Готовая команда захода"
  value       = "ssh ${var.admin_user}@${hcloud_server.vps.ipv4_address}"
}

output "next_steps" {
  description = "Что сделать руками после terraform apply"
  value       = <<-EOT
    1. A-запись ${var.domain} -> ${hcloud_server.vps.ipv4_address}
       Без неё Caddy не выпустит сертификат: проверка идёт по HTTP-01.
    2. ssh ${var.admin_user}@${hcloud_server.vps.ipv4_address}
    3. Заполнить /srv/qiymet/deploy/.env (пароль базы, токен телеграма, домен).
       Секреты сюда не едут через terraform: state их бы запомнил.
    4. cd /srv/qiymet/deploy && ./scripts/first-run.sh
  EOT
}
