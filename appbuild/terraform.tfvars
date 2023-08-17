region = "us-east-1"

linux = {
    instance_type = "t3a.large"
    assoc_pub_ip = true
    subnet_id = "subnet-0b51a3915c85da362"
    key = "tf-key"
    volume_size = 20
    ec2_tag = "AMAZON_LINUX_2"
}

windows = {
    instance_type = "t3a.large"
    assoc_pub_ip = true
    subnet_id = "subnet-0b51a3915c85da362"
    key = "tf-key"
    volume_size = 30
    ec2_tag = "WINDOWS"
}

################################### IAM Policy ###########################################
iam_policy = {
ec2_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:ListBucket",
                "s3:CreateBucket",
                "s3:PutObjectAcl",
                "s3:GetObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::s3-statefile-backup"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:HeadBucket"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster"
            ],
            "Resource": "*"
        }
    ]
}
POLICY

}
##########################################################################################

s3 = {
    bucket_name = "s3-bucket-0477"
}

alb = {
    alb_name = "test-alb"
    internal = false
    subnets_id = ["subnet-0b84218cf1706bc0f","subnet-0b51a3915c85da362","subnet-00c46563777fb4927"]
    vpc_id = "vpc-09166d3ab75915302"
    alb_sg_ingress = {
                ingress1 = {from="80", to="80", protocol="tcp", cidr_block="0.0.0.0/0", description="HTTP"}
                ingress2 = {from="443", to="443", protocol="tcp", cidr_block="0.0.0.0/0", description="HTTPS"}
    }
}

############################ Target Group and Listener rule #############################

tg = {
    application_name = "sample-app"
    application_port = 80
    application_health_check_target = "/health"
    vpc_id = "vpc-09166d3ab75915302"
    instance_id = "i-061c9863b6f1fe842"
}

listener_rule = {
    listener_type = "forward"
    path_pattern = "/*"
    host_header = "example.com"
}

###########################################################################################
sg = {
    vpc_id = "vpc-09166d3ab75915302"
    sg_ingress = {
                ingress1 = {from="22", to="22", protocol="tcp", cidr_block="0.0.0.0/0", description="SSH"}
                ingress2 = {from="3389", to="3389", protocol="tcp", cidr_block="0.0.0.0/0", description="RDP"}

    }
}

# dlm = {
#     policy_name = "1 snapshot every 12 hours"
#     policy_interval = "12"
#     policy_time = ["22:40"]
#     retain_time = "3"
# }

backup = {
    backup_vault_name = "backup_vault"
    backup_plan_name = "backup_plan"
    backup_schedule = "cron(0 */12 * * ? *)"
    cold_storage = 30
    delete_after = 120
    windows_VSS = "enabled"
    backup_selection_name = "ec2-backup-selection"
    resources = ["*"]
    selection_key = "Snapshot"
    selection_value = "true"
}

windows_patch = {
    maintainance_window_name = "win-maintainance-window"
    maintainance_cron_expression = "rate(7 days)"
    maintainance_duration = "3"
    maintainance_cutoff = "1"
    OS_TYPE = "WINDOWS"
    approval_after_days = "7"
    Classification = ["SecurityUpdates","Updates"]
    severity = ["Critical", "Important"]
    patch_group_name = "Windows Patch Group"
    approved_patches = ["KB2267602"]
    rejected_patches = null
    baseline_name = "Custom-Windows-Baseline"
}

linux_patch = {
    maintainance_window_name = "linux-maintainance-window"
    maintainance_cron_expression = "rate(7 days)"
    maintainance_duration = "3"
    maintainance_cutoff = "1"
    OS_TYPE = "AMAZON_LINUX_2"
    approval_after_days = "7"
    Classification = ["Security"]
    #patch_name = ["expat-static","expat"]
    patch_group_name = "AMZN Linux Patch Group"
    approved_patches = ["ALAS2-2023-1964"]
    rejected_patches = null
    baseline_name = "Custom-amzn-linux-Baseline"
}

