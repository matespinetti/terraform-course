#Public Bastion Host Security Group
module "public_bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name = "${local.name}-public-bastion-sg"
  description = "Security Group with SSH port open from everybody, egress ports are all open"
  vpc_id = module.vpc.vpc_id
  #Ingress rules and CIDR blocks
  ingress_with_cidr_blocks = [
    {
        rule = "ssh-tcp"
        cidr_blocks = "0.0.0.0/0"
    }
  ]
  #Egress rules and CIDR blocks
  egress_with_cidr_blocks = [
    {
        rule = "all-all"
        cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = local.common_tags
}


#Private App Server Security Grup
module "private_app_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name = "${local.name}-private-app-sg"
  description = "Security Group with HTTP and SSH port open from public bastion host, egress ports are all open"
  vpc_id = module.vpc.vpc_id


  computed_ingress_with_source_security_group_id = [
    {
        rule = "ssh-tcp"
        source_security_group_id = module.public_bastion_sg.security_group_id
    },
    {
        rule = "http-80-tcp"
        source_security_group_id = module.alb_sg.security_group_id
    }
  ]
  egress_with_cidr_blocks = [
    {
        rule = "all-all"
        cidr_blocks = "0.0.0.0/0"
    }
  ]

  number_of_computed_ingress_with_source_security_group_id = 2

  tags = local.common_tags

  
}


module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"


  name = "${local.name}-alb-sg"
  description = "Security Group with HTTP and HTTPS port open from the internet"
  vpc_id = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule = "https-443-tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      rule = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = local.common_tags
}


#Spring Boot App Security Group
module "spring_boot_app_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name = "${local.name}-spring-boot-app-sg"
}


#RDS Security Group
module "rds_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name = "${local.name}-rds-sg"
  description = "Security Group with MySQL port open from spring boot app and bastion host"
  vpc_id = module.vpc.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      rule = "mysql-tcp"
      source_security_group_id = module.spring_boot_app_sg.security_group_id
    },
    {
      rule = "mysql-tcp"
      source_security_group_id = module.public_bastion_sg.security_group_id
    }
  ]

  egress_with_cidr_blocks = [
    {
      rule = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = local.common_tags
}