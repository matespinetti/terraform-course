# Data Sources

data "aws_availability_zones" "available" {
    state = "available"
}

# Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
    most_recent = true
    owners = ["amazon"]
     filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

#Route 53 Hosted Zone
data "aws_route53_zone" "hosted_zone" {
  name         = var.domain_name
  private_zone = false
}