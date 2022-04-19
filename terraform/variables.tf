variable "zone" {
  description = "Zone"
  default     = "ru-central1-a"
}
variable "cloud_id" {
  description = "Cloud"
}
variable "folder_id" {
  description = "Folder"
}

variable "instance_count" {
  description = "Amount of instances"
  default     = 1
}
variable "service_account_key_file" {
  description = "key .json"
}
variable "bucket_name" {
  description = "Name of storage"
  default     = "state_storage"
}
variable "access_key" {
  description = "Key ID"
}
variable "secret_key" {
  description = "secret"
}
