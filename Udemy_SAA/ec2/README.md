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

# Elastic Network Interfaces (ENI)

- EC2 -> Network interfaces -> Create network interface

# EC2 Hibernate

- When creating EC2 instance -> Stop-Hibernate behavior: enable

# EBS

- EC2 -> Instances -> Choose instance -> Storage
- EC2 -> Volumes -> Create volume
- Actions -> Attatch volume

# EBS Snapshot

- EC2 -> Volumes -> Choose volume -> Actions -> Create snapshot
- EC2 -> Snapshots -> choose snapshot -> Copy snapshot, create volume from snapshot, Archive tier
- Recycle Bin -> Retention rules -> Create retention rule
- Recycle Bin -> Resources -> Choose snapshot -> Recover

# AMI

- EC2 -> Instances -> Choose instace -> Create image
- EC2 -> AMIs
- Create instance -> my amis

# EBS Encryption

- Choose snapshot -> Actions -> Copy snapshot -> Encrypt this snapshot

# EFS

- EFS -> Create file system
- When creating instance -> Network settings -> Subnet -> EBS Volumes: File systems
- ls /mnt/efs/fsl/ + sudo su + echo "" > /mnt/efs/fsl/hello.txt

# ALB (Application Load Balancer)

- EC2 -> Load Balancer -> Create Load Balancer -> Create Application Load Balancer -> IP address type: Ipv4 + Network Mapping + Security groups + Listeners and routing, create Target groups + Edit inbound rules of security group
- Add rules:

# NLB (Network Load Balancer)

# Elastic Load Balancer - Sticky Sessions

- EC2 -> Target groups -> Choose target group -> Actions -> Edit attributes -> Turn on stickiness -> Stickiness type: Load balancer generated cookie -> Stickiness duration: 1 + Unit of time: days

# Elastic Load Balancer - Cross Zone Load Balancing

- Choose Load Balancer -> Attribute: Edit -> Cross-zone load balancing
