module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  #VPC Basic Details
  name = local.vpc_name
  cidr = local.vpc_cidr_block
  azs = local.azs
  private_subnets = local.private_subnets
  public_subnets = local.public_subnets


  #Database subnets
  database_subnets = local.database_subnets
  create_database_subnet_group = true
  create_database_subnet_route_table = true
  # create_database_internet_gateway_route = true
  # create_database_nat_gateway_route = true


  #NAT Gateways - Outbound communication
  enable_nat_gateway = var.enable_nat_gateway# This is false by default. 
  single_nat_gateway = var.single_nat_gateway # This is false by default. 

  #VPC DNS Paramaters
  enable_dns_hostnames = var.create_database_subnet_group # By default true
  enable_dns_support = var.create_database_subnet_route_table # By default true

  #VPC Tags
  public_subnet_tags = {
    Type = "Public Subnet"
  }
  private_subnet_tags = {
    Type = "Private Subnet"
  }
  database_subnet_tags = {
    Type = "Database Subnet"
  }
  tags = local.common_tags
  vpc_tags = local.common_tags
}