variable "launch_template_name" {}
variable "volume_size" {}
variable "delete_on_termination" {}
variable "volume_type" {}
variable "instance_type" {}
variable "security_group" {
 type = list
}
variable "key_name" {}
variable "iam_instance_profile" {}
variable "autoscaling_group_name" {}
variable "max_size" {}
variable "min_size" {}
variable "desired_capacity" {}
variable "subnet_ids" {
  type = list
}
variable "target_group_arns" {

}
variable "ec2_tag" {}
variable "scaling_policy_name" {}
variable "threshold_value" {}
variable "ami_id" {}
variable "efs_id" {}