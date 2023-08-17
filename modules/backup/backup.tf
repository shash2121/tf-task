resource "aws_backup_plan" "main" {
  name = var.backup_plan_name

  rule {
    rule_name         = "backup_rule"
    target_vault_name = aws_backup_vault.main.name
    schedule          = var.backup_schedule

    lifecycle {
      cold_storage_after = var.cold_storage
      delete_after       = var.delete_after
    }
  }

  advanced_backup_setting {
    backup_options = {
      WindowsVSS = var.windows_VSS
    }
    resource_type = "EC2"
  }
}

resource "aws_backup_selection" "main" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = var.backup_selection_name
  plan_id      = aws_backup_plan.main.id
  resources    = var.resources

  condition {
    string_equals {
      key   = "aws:ResourceTag/${var.selection_key}"
      value = var.selection_value
    }
  }
}