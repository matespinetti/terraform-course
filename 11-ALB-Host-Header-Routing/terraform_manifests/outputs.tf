

# VPC Outputs
output "availability_zones" {
    description = "Availability Zones"
    value = local.azs
}

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



#Security Group Outputs
output "public_bastion_sg_info" {
    description = "Public Bastion Security Group Info"
    value = {
        sg_id = module.public_bastion_sg.security_group_id
        sg_name = module.public_bastion_sg.security_group_name
        vpc_id = module.public_bastion_sg.security_group_vpc_id
    }
}

output "private_app_sg_info" {
    description = "Private App Security Group Info"
    value = {
        sg_id = module.private_app_sg.security_group_id
        sg_name = module.private_app_sg.security_group_name
        vpc_id = module.private_app_sg.security_group_vpc_id
    }
}   


#Bastion Host Outputs
output "bastion_host_info" {
    description = "Bastion Host Info"
    value = {
        bastion_host_id = module.ec2_bastion_host.id
        bastion_host_public_ip = module.ec2_bastion_host.public_ip
    }
}

#Private App Server Outputs
output "private_app1_servers_info" {
    description = "Private App Servers Info"
    value = {
        for key, instance in module.ec2_private_app1_server : key =>{
            instance_id = instance.id
            instance_private_ip = instance.private_ip
            instance_az = instance.availability_zone
        
        }
    }
}

output "private_app2_servers_info" {
    description = "Private App Servers Info"
    value = {
        for key, instance in module.ec2_private_app2_server : key =>{
            instance_id = instance.id
            instance_private_ip = instance.private_ip
            instance_az = instance.availability_zone
        }
    }
}


#Load balancer Outputs
output "alb_info" {
    description = "Information about the Application Load Balancer"
    value = {
        alb_id = module.alb.id
        alb_arn = module.alb.arn
        alb_dns_name = module.alb.dns_name
        alb_zone_id = module.alb.zone_id
      
        
    }
}


#Route 53 Hosted Zone Outputs
output "hosted_zone_info" {
    description = "Route 53 Hosted Zone Info"
    value = {
        hosted_zone_id = data.aws_route53_zone.hosted_zone.id
        hosted_zone_name = data.aws_route53_zone.hosted_zone.name
    }
}

#ACM Outputs
output "acm_info" {
    description = "ACM Info"
    value = {
        acm_arn = module.acm.acm_certificate_arn
    }
}

