resource "aws_ssm_maintenance_window" "window" {
  name     = var.maintainance_window_name
  schedule = var.maintainance_cron_expression
  duration = var.maintainance_duration
  cutoff   = var.maintainance_cutoff
}

resource "aws_ssm_maintenance_window_target" "target1" {
  window_id     = aws_ssm_maintenance_window.window.id
  name          = "maintenance-window-target"
  description   = "This is a maintenance window target"
  resource_type = "INSTANCE"

  targets {
    key    = "tag:OS_TYPE"
    values = [var.OS_TYPE]
  }
}

###############Patch Baselines#####################
resource "aws_ssm_patch_baseline" "os_apps" {
  name             = var.baseline_name
  description      = "Patch"
  approved_patches = var.approved_patches
  rejected_patches = var.rejected_patches
  operating_system = var.OS_TYPE

  approval_rule {
    approve_after_days = var.approval_after_days

    patch_filter {
      key    = "CLASSIFICATION"
      values = var.Classification
    }

    patch_filter {
      key    = "MSRC_SEVERITY"
      values = var.severity
    }
  }

}

######################Patch Group#########################
resource "aws_ssm_patch_group" "patchgroup" {
  baseline_id = aws_ssm_patch_baseline.os_apps.id
  patch_group = var.patch_group_name
}