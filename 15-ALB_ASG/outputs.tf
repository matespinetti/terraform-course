# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value = module.vpc.vpc_cidr_block
}

# Security Group Outputs
output "bastion_sg_id" {
  description = "Bastion security group ID"
  value = module.security.public_bastion_sg_id
}

output "alb_sg_id" {
  description = "ALB security group ID"
  value = module.security.alb_sg_id
}

# Compute Outputs
output "bastion_public_ip" {
  description = "Bastion host public IP"
  value = module.compute.bastion_host_public_ip
}



# Load Balancer Outputs
output "alb_dns_name" {
  description = "ALB DNS name"
  value = module.loadbalancer.alb_dns_name
}

output "alb_zone_id" {
  description = "ALB zone ID"
  value = module.loadbalancer.alb_zone_id
}

# Database Outputs
output "db_instance_endpoint" {
  description = "RDS instance endpoint"
  value = module.database.db_instance_endpoint
}

# DNS Outputs
output "alb_dns_record" {
  description = "ALB DNS record"
  value = module.dns.alb_dns_record_name
}

output "certificate_arn" {
  description = "ACM certificate ARN"
  value = module.dns.acm_certificate_arn
}