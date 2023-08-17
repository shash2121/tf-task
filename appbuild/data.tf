data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]  # You can specify the AWS account IDs that own the AMIs, e.g., ["self"] for your account
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]  # Replace this with the Amazon Linux 2 AMI name pattern you want to search for
  }
}

#===============================Windows AMI===========================
data "aws_ami" "windows" {
     most_recent = true    
     owners = ["801119661308"] # Canonical}
    filter {
       name   = "name"
       values = ["Windows_Server-2019-English-Full-Base-*"]  
  }     
  filter {
       name   = "virtualization-type"
       values = ["hvm"]  
  }     
}