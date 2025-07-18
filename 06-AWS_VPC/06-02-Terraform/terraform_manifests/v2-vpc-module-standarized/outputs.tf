output "vpc_info" {
    description = "VPC Info"
    value = {
        vpc_id = module.vpc.vpc_id
        vpc_cidr_block = module.vpc.vpc_cidr_block
        nat_public_ips = module.vpc.nat_public_ips

        public_subnets = [
            for idx, subnet in module.vpc.public_subnet_objects : {
                subnet_id = subnet.id
                subnet_cidr_block = subnet.cidr_block
                subnet_availability_zone = subnet.availability_zone
            }
        ]

        private_subnets = [
            for idx, subnet in module.vpc.private_subnet_objects : {
                subnet_id = subnet.id
                subnet_cidr_block = subnet.cidr_block
                subnet_availability_zone = subnet.availability_zone
            }
        ]
        
        database_subnets = [
            for idx, subnet in module.vpc.database_subnet_objects : {
                subnet_id = subnet.id
                subnet_cidr_block = subnet.cidr_block
                subnet_availability_zone = subnet.availability_zone
            }
        ]
    }
}

output "availability_zones" {
    description = "Availability Zones"
    value = local.azs
}