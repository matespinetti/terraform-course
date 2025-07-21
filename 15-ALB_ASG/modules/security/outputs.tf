output "public_bastion_sg_id" {
  description = "ID of the public bastion security group"
  value = module.public_bastion_sg.security_group_id
}


output "alb_sg_id" {
  description = "ID of the ALB security group"
  value = module.alb_sg.security_group_id
}

output "spring_boot_app_sg_id" {
  description = "ID of the Spring Boot app security group"
  value = module.spring_boot_app_sg.security_group_id
}

output "rds_sg_id" {
  description = "ID of the RDS security group"
  value = module.rds_sg.security_group_id
}