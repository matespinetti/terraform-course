locals {
    owners = var.business_division
    environment = var.environment
    name = "${local.owners}-${local.environment}"
    common_tags = {
        owners = local.owners
        environment = local.environment
    }


    ## VPC locals
    vpc_name = "${local.name}-${var.vpc_name}"
    vpc_cidr_block = var.vpc_cidr_block
    azs = slice(data.aws_availability_zones.available.names, 0, 2)
    public_subnets = [for k,v in local.azs : cidrsubnet(local.vpc_cidr_block, 8, k)]
    private_subnets = [for k,v in local.azs : cidrsubnet(local.vpc_cidr_block, 8, k + 10)]
    database_subnets = [for k,v in local.azs : cidrsubnet(local.vpc_cidr_block, 8, k + 20)]

    #EC2 locals
    amazon_linux_2023_ami_id = data.aws_ami.amazon_linux_2023.id
    private_instances = {
        for i in range(var.private_app_instance_count):
            "private-app-${i+1}" => {
                subnet_id = module.vpc.private_subnets[i % length(module.vpc.private_subnets)]
                instance_name = "${local.name}-private-app-${i+1}"
            }
    }
}


