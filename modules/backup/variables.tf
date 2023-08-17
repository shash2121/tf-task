variable "backup_vault_name" {}
variable "backup_plan_name" {}
variable "backup_schedule" {}
variable "cold_storage" {
    description = "specify the number of days after which backup is moved to cold storage"
}
variable "delete_after" {
    description = "specify the number of days after which backup is deleted"
}
variable "windows_VSS" {}
variable "backup_selection_name" {}
variable "resources" {
  description = "list of resources for which backup is to be enabled"
  type = list
}
variable "selection_key" {}
variable "selection_value" {}