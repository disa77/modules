# Получение текущей конфигурации клиента (folder_id по умолчанию)
data "yandex_client_config" "client" {}

# Локальные переменные
locals {
  folder_id = var.folder_id == null ? data.yandex_client_config.client.folder_id : var.folder_id
  vpc_id    = var.create_vpc ? yandex_vpc_network.this[0].id : var.vpc_id
}

# Создание VPC-сети (если create_vpc = true)
resource "yandex_vpc_network" "this" {
  count       = var.create_vpc ? 1 : 0
  description = var.network_description
  name        = var.network_name
  labels      = var.labels
  folder_id   = local.folder_id
}

# Создание подсетей (имя задаётся явно через subnets.name)
resource "yandex_vpc_subnet" "this" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  name           = each.value.name
  description    = "${var.network_name} subnet for zone ${each.value.zone}"
  v4_cidr_blocks = [each.value.v4_cidr_blocks]
  zone           = each.value.zone
  network_id     = local.vpc_id
  folder_id      = local.folder_id

  dhcp_options {
    domain_name         = var.domain_name == null ? "internal." : var.domain_name
    domain_name_servers = var.domain_name_servers == null ? [cidrhost(each.value.v4_cidr_blocks, 2)] : var.domain_name_servers
    ntp_servers         = var.ntp_servers == null ? ["ntp0.NL.net", "clock.isc.org", "ntp.ix.ru"] : var.ntp_servers
  }

  labels = var.labels
}

# Outputs (пример)
output "network_id" {
  value = local.vpc_id
}

output "subnet_ids" {
  value = { for k, v in yandex_vpc_subnet.this : k => v.id }
}
