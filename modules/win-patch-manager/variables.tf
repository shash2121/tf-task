variable "maintainance_window_name" {}
variable "maintainance_cron_expression" {}
variable "maintainance_duration" {}
variable "maintainance_cutoff" {}
variable "OS_TYPE" {}
variable "approval_after_days" {}
variable "Classification" {
  type = list
}
variable "severity" {
  type = list
}
variable "patch_group_name"{}
variable "baseline_name" {}
variable "approved_patches" {}
variable "rejected_patches" {}