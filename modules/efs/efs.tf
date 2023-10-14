resource "aws_security_group" "efs" {
  vpc_id      = var.vpc_id
  

  ingress {
    description      = "TLS from VPC"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    security_groups = [var.security_group_id]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "efs-sg"
  }
}


resource "aws_efs_file_system" "efs_file_system" {
  creation_token   = "my-efs"
  performance_mode = "generalPurpose" 

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = var.efs_name
  }

#   vpc_id          = var.vpc_id
#   security_groups = [aws_security_group.efs.id]
#   subnet_ids     = var.subnet_ids
}

resource "aws_efs_mount_target" "mount_target" {
  count = length(var.subnet_ids)

  file_system_id  = aws_efs_file_system.efs_file_system.id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = [aws_security_group.efs.id]
}

output "efs_id" {
  value = aws_efs_file_system.efs_file_system.id
}