terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

resource "yandex_compute_instance" "app" {
  name = "reddit-app-${var.env}"

  labels = {
    tags = "reddit-app"
  }
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.app_disk_image
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}

resource "null_resource" "app" {
  count = var.enable_deploy ? 1 : 0
  triggers = {
    cluster_instance_ids = yandex_compute_instance.app.id
  }
  connection {
    type        = "ssh"
    host        = yandex_compute_instance.app.network_interface.0.nat_ip_address
    user        = "ubuntu"
    agent       = false
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    content     = templatefile("../files/puma.service.tftpl", { database_ip = var.database_ip })
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "../files/deploy.sh"
  }
}
