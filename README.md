- login to terraform-ec2 instance using ec2-instance connect.

- Switch directory to tf-task/appbuild

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
- Route53 public and private zone.
- Records inside these zones.
- ASG for linux.
- EFS

- Note:
  Storing the state file in s3 bucket "s3-statefile-backup" mentioned in appbuild/backend-s3

Update [17 Aug]:
- Modified IAM role for EC2, added policy for session manager.
- Removed the tfvars for lifecycle management for EC2.
- Added AWS backup, which will be applied to all resource having tag "Snapshot:true"

Update [14 Oct]:
- Created route53 module which can create public/private hosted zones.
- Also, DNS records can be created in these zones by specifying the zone type as either private/ public.
- Created EFS and its security group with the required inbound rules. It has mount targets in all the availability zones in the us-east-1 region, so instance launched in any AZ can have EFS mounted on it.

- Created ASG for the linux instances.
- The user-data specified in the ASG will autmatically mount the EFS on the instances in the 
/home/ubuntu/efs directory.
- This process is automated which means if additional instances are added to ASG, then also EFS will be mounted on them.
