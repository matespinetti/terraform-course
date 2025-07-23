# VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_name = local.vpc_name
  vpc_cidr_block = local.vpc_cidr_block
  azs = local.azs
  public_subnets = local.public_subnets
  private_subnets = local.private_subnets
  database_subnets = local.database_subnets
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  create_database_subnet_group = var.create_database_subnet_group
  create_database_subnet_route_table = var.create_database_subnet_route_table
  enable_dns_hostnames = true
  enable_dns_support = true
  common_tags = local.common_tags
}

# Security Module
module "security" {
  source = "./modules/security"

  name_prefix = local.name
  vpc_id = module.vpc.vpc_id
  common_tags = local.common_tags
}

# DNS Module (needs to be created before compute for certificate)
module "dns" {
  source = "./modules/dns"

  domain_name = var.domain_name
  alb_dns_name = module.loadbalancer.alb_dns_name
  alb_zone_id = module.loadbalancer.alb_zone_id
  common_tags = local.common_tags
}

# Compute Module
module "compute" {
  source = "./modules/compute"

  name_prefix = local.name
  ami_id = local.amazon_linux_2023_ami_id
  bastion_host_instance_type = var.bastion_host_instance_type
  bastion_host_key_pair_name = var.bastion_host_key_pair_name
  private_app_instance_type = var.private_app_instance_type
  private_app_instance_key_pair_name = var.private_app_instance_key_pair_name
  public_subnet_ids = module.vpc.public_subnets
  private_subnet_ids = module.vpc.private_subnets
  public_bastion_sg_id = module.security.public_bastion_sg_id
  private_instances_spring_boot_app = local.private_instances_spring_boot_app
  spring_boot_app_sg_id = module.security.spring_boot_app_sg_id
  web_app_db_name = var.web_app_db_name
  web_app_db_username = var.web_app_db_username
  web_app_db_password = var.web_app_db_password
  web_app_db_port = var.web_app_db_port
  web_app_db_endpoint = module.database.db_instance_endpoint
  private_key_content = file("${path.module}/private-key/${var.bastion_host_key_pair_name}.pem")
  common_tags = local.common_tags
  vpc_ready = module.vpc
  spring_boot_app_target_group_arn = module.loadbalancer.target_groups["spring_boot_app_tg"].arn
  alb_arn = module.loadbalancer.alb_arn

}

# Database Module
module "database" {
  source = "./modules/database"

  db_instance_identifier = var.web_app_db_instance_identifier
  db_instance_class = var.web_app_db_instance_class
  db_name = var.web_app_db_name
  db_username = var.web_app_db_username
  db_password = var.web_app_db_password
  db_port = var.web_app_db_port
  database_subnet_group_name = module.vpc.database_subnet_group
  rds_sg_id = module.security.rds_sg_id
  common_tags = local.common_tags
}

# Load Balancer Module
module "loadbalancer" {
  source = "./modules/loadbalancer"
  alb_name = local.alb_name
  vpc_id = module.vpc.vpc_id
  alb_subnets = local.alb_subnets
  alb_sg_id = module.security.alb_sg_id
  certificate_arn = module.dns.acm_certificate_arn
  domain_name = var.domain_name
  common_tags = local.common_tags
}

# Notifications Module
module "monitoring" {
  source = "./modules/monitoring"
  name_prefix = local.name
  email_address = var.email_address
  spring_boot_app_asg_name = module.compute.spring_boot_asg_name
  alb_arn_suffix = module.loadbalancer.alb_arn_suffix
  spring_boot_app_target_group_arn = module.loadbalancer.target_groups["spring_boot_app_tg"].arn_suffix
  common_tags = local.common_tags
}