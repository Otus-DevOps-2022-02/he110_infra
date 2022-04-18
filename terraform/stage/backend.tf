terraform {
  required_version = ">= 0.13"
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "terraform-remote-backend"
    region     = "ru-central1"
    key        = "states/stage.tfstate"
    access_key = "YCAJE3I0ri-YniPclbaQxRbuY"
    secret_key = "YCMk6KcgDJwfN4BGWMfuDmKS2Uk6Tks7aUbDOGWY"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
