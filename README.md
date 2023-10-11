- Switch directory to appbuild.

- Run commands:
 
``` terraform init ```
 
``` terraform plan ```

``` terraform apply ```

Following resources are created:
- ec2 instance (Amazon linux)
- ec2 instance (windows)
- security group
- load balancer
- target group
- listener rule
- linux patch manager with baseline
- windows patch manager with baseline
- s3 bucket
- IAM role to be attached to ec2 instances

- Note:
  Storing the state file in s3 bucket "s3-statefile-backup" mentioned in appbuild/backend-s3

Update [17 Aug]:
- Modified IAM role for EC2, added policy for session manager.
- Removed the tfvars for lifecycle management for EC2.
- Added AWS backup, which will be applied to all resource having tag "Snapshot:true"



Note: In terraform.tfvars line 86, replace the instance ID with ID of a running instance, then entire code will work fine.