terraform {
  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket   = "state-storage"
    region   = "ru-central1"
    key      = "states/stage.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
