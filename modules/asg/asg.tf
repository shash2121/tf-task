data "template_file" "user_data" {
  template = "${file("../user-data/user_data.tpl")}"

  vars = {
    EFS_ID = var.efs_id
  }
}

resource "aws_launch_template" "launch_template" {
  name_prefix = var.launch_template_name
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.volume_size
      delete_on_termination = var.delete_on_termination
      volume_type = var.volume_type
    }
  }
  instance_type = var.instance_type 
  image_id = var.ami_id
  vpc_security_group_ids = var.security_group
  key_name = var.key_name 
  iam_instance_profile {
    name = var.iam_instance_profile
  }
  user_data = "${base64encode(data.template_file.user_data.rendered)}"
}

resource "aws_autoscaling_group" "asg" {
  name                      = var.autoscaling_group_name
  max_size                  = var.max_size      
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.subnet_ids
  
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  target_group_arns = ["${var.target_group_arns}"]

  tag {
    key                 = "OS_TYPE"
    value               = "${var.ec2_tag}"
    propagate_at_launch = true
  }
  tag {
    key                 = "Snapshot"
    value               = true
    propagate_at_launch = true
  }

}

resource "aws_autoscaling_policy" "scaling_policy" {
  name                   = var.scaling_policy_name
  policy_type            = "TargetTrackingScaling"
  estimated_instance_warmup = 120 
  autoscaling_group_name = aws_autoscaling_group.asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.threshold_value
  }
}
