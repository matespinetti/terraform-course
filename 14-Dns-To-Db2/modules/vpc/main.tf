module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  # VPC Basic Details
  name = var.vpc_name
  cidr = var.vpc_cidr_block
  azs = var.azs
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets

  # Database subnets
  database_subnets = var.database_subnets
  create_database_subnet_group = var.create_database_subnet_group
  create_database_subnet_route_table = var.create_database_subnet_route_table

  # NAT Gateways - Outbound communication
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  # VPC DNS Parameters
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support

  # VPC Tags
  public_subnet_tags = {
    Type = "Public Subnet"
  }
  private_subnet_tags = {
    Type = "Private Subnet"
  }
  database_subnet_tags = {
    Type = "Database Subnet"
  }
  tags = var.common_tags
  vpc_tags = var.common_tags
}