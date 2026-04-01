# Instance Types

- Link: aws.amazon.com/ec2/instance-types/

# SSH

- chmod 0400 <file.pem\>
- ssh -i <file.pem\> ec2-user@<public-ip\>

# EC2 Instance Roles Demo

- aws --version
- aws configure -> input access -> bad idea
- Instances -> Choose instance -> Actions -> Security -> Modify IAM Role
- Check: aws iam list-users

# EC2 Instances Lauch Types

- Spot Request -> Request Spot Instances -> Create Spot Fleet request

# Elastic IP

- EC2 -> Elastic IP addresses -> Allocate Elastic IP address
- aws.amazon.com/vpc/pricing
- Actions -> Associate elastic IP address

# Placement Group

- EC2 -> Placement Groups -> Create Placement Group
- When creating instance, you can add it to the created placement groups.
