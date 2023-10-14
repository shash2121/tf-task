#!/bin/bash

sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm

sudo yum -y install amazon-efs-utils

sudo mkdir /home/ec2-user/efs

sudo mount -t efs -o tls ${EFS_ID}:/ home/ec2-user/efs