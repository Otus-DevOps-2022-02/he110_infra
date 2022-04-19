provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

module "app" {
  source           = "../modules/app"
  env              = "prod"
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  app_disk_image   = var.app_disk_image
  subnet_id        = var.subnet_id
  enable_deploy    = true
  database_ip      = module.db.external_ip_address_db
}

module "db" {
  source           = "../modules/db"
  env              = "prod"
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  db_disk_image    = var.db_disk_image
  subnet_id        = var.subnet_id
  enable_deploy    = true
}
