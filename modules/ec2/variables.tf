variable "instance_type" {}
variable "ami_id" {}
variable "sg_id" {}
variable "subnet_id" {}
variable "assoc_pub_ip" {
    default = true
}
variable "key" {}
variable "ec2_tag" {
  
}
variable "iam_instance_profile" {}
variable "volume_size" {
default = 20  
}