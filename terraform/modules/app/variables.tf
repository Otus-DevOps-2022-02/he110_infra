variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}
variable "private_key_path" {
  description = "Path to the private key file"
}
variable "app_disk_image" {
  description = "Disk image for reddit app"
  default     = "reddit-app"
}
variable "subnet_id" {
  description = "Subnets for modules"
}
variable "env" {
  description = "Instance environment type"
  default     = "prod"
}
variable "enable_deploy" {
  description = "Set to true if you want deploy app"
  default     = true
  type        = bool
}
variable "database_ip" {
  description = "Database instance IP"
}
