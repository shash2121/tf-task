terraform {
  backend "s3" {
    bucket         = "s3-statefile-backup"
    key            = "newinfra/terraform.tfstate"
    encrypt        = true
    region         = "us-east-1"
  }
}