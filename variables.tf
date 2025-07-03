variable "network_name" {
  description = "Имя VPC-сети (должно быть уникальным в рамках облака)."
  type        = string
}

variable "network_description" {
  description = "Описание VPC-сети."
  type        = string
  default     = null
}

variable "labels" {
  description = "Ключ-значение меток для ресурсов (VPC и подсетей)."
  type        = map(string)
  default     = {}
}

variable "create_vpc" {
  description = "Создавать ли новую VPC-сеть (true) или использовать существующую (false)."
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "ID существующей VPC-сети (используется, если create_vpc = false)."
  type        = string
  default     = null
}

variable "folder_id" {
  description = "ID каталога (folder) Yandex Cloud. Если не задан, будет использован folder_id из профиля пользователя."
  type        = string
  default     = null
}

variable "subnets" {
  description = <<-EOT
    Список подсетей для создания. 
    Каждая подсеть должна содержать:
      - name           (строка, уникальное имя подсети, только латиница, цифры, дефисы, начинается с буквы)
      - zone           (строка, например, ru-central1-a)
      - v4_cidr_blocks (строка, например, 10.130.0.0/16)
    Пример:
      subnets = [
        {
          name           = "subnet-a"
          zone           = "ru-central1-a"
          v4_cidr_blocks = "10.130.0.0/16"
        }
      ]
  EOT

  type = list(object({
    name           = string
    zone           = string
    v4_cidr_blocks = string
  }))
}

variable "domain_name" {
  description = "DHCP: имя домена для подсетей (по умолчанию internal.)"
  type        = string
  default     = null
}

variable "domain_name_servers" {
  description = "DHCP: список DNS-серверов для подсетей (по умолчанию IP шлюза подсети)"
  type        = list(string)
  default     = null
}

variable "ntp_servers" {
  description = "DHCP: список NTP-серверов для подсетей"
  type        = list(string)
  default     = null
}
