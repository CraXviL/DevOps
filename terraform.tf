terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

variable "image-id" {
  type = string
}

provider "yandex" {
  token  =  "YC_TOKEN"
  cloud_id  = "YC_CLOUD_ID"
  folder_id = "YC_FOLDER_ID"
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "vm_1" {
  name        = "vm_1"
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = var.image-id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ecdsa.pub")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "from-terraform-network"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "from-terraform-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["10.1.0.0/16"]
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm_1.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm_1.network_interface.0.nat_ip_address
}
