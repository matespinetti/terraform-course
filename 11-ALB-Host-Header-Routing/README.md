# Terraform AWS Application Load Balancer (ALB) with SSL/TLS

This Terraform configuration creates an AWS Application Load Balancer with SSL/TLS termination, distributing traffic to multiple EC2 instances running different applications.

## Architecture

- **VPC**: Custom VPC with public and private subnets across multiple AZs
- **ALB**: Application Load Balancer in public subnets with SSL/TLS termination
- **EC2 Instances**: Private instances running App1 and App2
- **ACM Certificate**: SSL certificate for HTTPS traffic
- **Security Groups**: Controlling traffic flow between components

## Features

- HTTPS redirect from HTTP (port 80 ’ 443)
- Path-based routing:
  - `/app1/*` ’ App1 target group
  - `/app2/*` ’ App2 target group
- Health checks for target groups
- Auto Scaling Groups for high availability
- Bastion host for SSH access to private instances

## Prerequisites

- AWS CLI configured
- Terraform installed
- Domain name for SSL certificate (update in variables)

## Deployment

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review and modify variables in `dev.auto.tfvars`

3. Plan the deployment:
   ```bash
   terraform plan
   ```

4. Apply the configuration:
   ```bash
   terraform apply
   ```

## Access

- **ALB DNS Name**: Available in Terraform outputs
- **App1**: https://your-domain.com/app1/
- **App2**: https://your-domain.com/app2/

## Cleanup

```bash
terraform destroy
```