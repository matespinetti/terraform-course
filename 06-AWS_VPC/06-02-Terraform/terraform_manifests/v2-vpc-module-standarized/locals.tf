locals {
    owners = var.business_division
    environment = var.environment
    name = "${local.owners}-${local.environment}"
    common_tags = {
        owners = local.owners
        environment = local.environment
    }
}

data "aws_availability_zones" "available" {
    state = "available"
}

locals  {
    vpc_name = "${local.name}-${var.vpc_name}"
    vpc_cidr_block = var.vpc_cidr_block
    azs = slice(data.aws_availability_zones.available.names, 0, 2)
    public_subnets = [for k,v in local.azs : cidrsubnet(local.vpc_cidr_block, 8, k)]
    private_subnets = [for k,v in local.azs : cidrsubnet(local.vpc_cidr_block, 8, k + 10)]
    database_subnets = [for k,v in local.azs : cidrsubnet(local.vpc_cidr_block, 8, k + 20)]
}