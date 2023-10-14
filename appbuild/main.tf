module "iam_instance_profile" {
  source = "../modules/IAM"
  ec2_policy = var.iam_policy.ec2_policy
}

# module "linux_ec2" {
#   depends_on = [ module.iam_instance_profile]
#   source = "../modules/ec2"
#     instance_type = var.linux.instance_type
#     ami_id = data.aws_ami.amazon_linux_2.id #fetching AMZN linux AMI
#     assoc_pub_ip = var.linux.assoc_pub_ip
#     sg_id = module.app-sg.sg_id
#     subnet_id = var.linux.subnet_id
#     key = var.linux.key
#     volume_size = var.linux.volume_size
#     ec2_tag = var.linux.ec2_tag
#     iam_instance_profile = module.iam_instance_profile.iam_instance_profile
# }

module "linux_asg" {
  depends_on = [module.efs]
  source = "../modules/asg"
  launch_template_name = var.asg_linux.launch_template_name
  volume_size = var.asg_linux.volume_size
  volume_type = var.asg_linux.volume_type
  delete_on_termination = var.asg_linux.delete_on_termination
  instance_type = var.asg_linux.instance_type
  ami_id = data.aws_ami.amazon_linux_2.id
  security_group = [module.app-sg.sg_id]
  key_name = var.asg_linux.key_name
  iam_instance_profile = module.iam_instance_profile.iam_instance_profile
  autoscaling_group_name = var.asg_linux.autoscaling_group_name
  max_size = var.asg_linux.max_size
  min_size = var.asg_linux.min_size
  desired_capacity = var.asg_linux.desired_capacity
  subnet_ids = var.asg_linux.subnet_ids
  target_group_arns = module.target_group.target_group_arn
  ec2_tag = var.asg_linux.ec2_tag
  scaling_policy_name = var.asg_linux.scaling_policy_name
  threshold_value = var.asg_linux.threshold_value
  efs_id = module.efs.efs_id

}

module "windows_ec2" {
  depends_on = [ module.iam_instance_profile]
  source = "../modules/ec2"
    instance_type = var.windows.instance_type
    ami_id = data.aws_ami.windows.id #fetching windows AMI
    assoc_pub_ip = var.windows.assoc_pub_ip
    sg_id = module.app-sg.sg_id
    subnet_id = var.windows.subnet_id
    key = var.windows.key
    ec2_tag = var.windows.ec2_tag
    volume_size = var.windows.volume_size
    iam_instance_profile = module.iam_instance_profile.iam_instance_profile
}



module "app-sg"{
  source = "../modules/sg"
  id_vpc = var.sg.vpc_id
  sg_ingress = var.sg.sg_ingress
}

# module "lifecycle_policy" {
#   source = "../modules/lifecycle-policy"
#   policy_name = var.dlm.policy_name
#   policy_interval = var.dlm.policy_interval
#   policy_time = var.dlm.policy_time
#   retain_time = var.dlm.retain_time
# }

module "backup_plan" {
  source = "../modules/backup"
  backup_plan_name = var.backup.backup_plan_name
  backup_vault_name = var.backup.backup_vault_name
  backup_schedule = var.backup.backup_schedule
  cold_storage = var.backup.cold_storage
  delete_after = var.backup.delete_after
  windows_VSS = var.backup.windows_VSS
  backup_selection_name = var.backup.backup_selection_name
  resources = var.backup.resources
  selection_key = var.backup.selection_key
  selection_value = var.backup.selection_value
}

module "windows_patch" {
  source = "../modules/win-patch-manager"
  maintainance_window_name = var.windows_patch.maintainance_window_name
  maintainance_cron_expression = var.windows_patch.maintainance_cron_expression
  maintainance_duration = var.windows_patch.maintainance_duration
  maintainance_cutoff = var.windows_patch.maintainance_cutoff
  OS_TYPE = var.windows_patch.OS_TYPE
  approval_after_days = var.windows_patch.approval_after_days
  Classification = var.windows_patch.Classification
  severity = var.windows_patch.severity
  patch_group_name = var.windows_patch.patch_group_name
  baseline_name = var.windows_patch.baseline_name
  approved_patches = var.windows_patch.approved_patches
  rejected_patches = var.windows_patch.rejected_patches
}

module "linux_patch" {
  source = "../modules/linux-patch-manager"
  maintainance_window_name = var.linux_patch.maintainance_window_name
  maintainance_cron_expression = var.linux_patch.maintainance_cron_expression
  maintainance_duration = var.linux_patch.maintainance_duration
  maintainance_cutoff = var.linux_patch.maintainance_cutoff
  OS_TYPE = var.linux_patch.OS_TYPE
  approval_after_days = var.linux_patch.approval_after_days
  Classification = var.linux_patch.Classification
  #patch_name = var.linux_patch.patch_name
  patch_group_name = var.linux_patch.patch_group_name
  baseline_name = var.linux_patch.baseline_name
  approved_patches = var.linux_patch.approved_patches
  rejected_patches = var.linux_patch.rejected_patches
}

module "efs" {
  source = "../modules/efs"
  security_group_id = module.app-sg.sg_id
  vpc_id = var.efs.vpc_id
  subnet_ids = var.efs.subnet_ids
  efs_name = var.efs.efs_name
}