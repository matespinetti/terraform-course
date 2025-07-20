output "db_instance_endpoint" {
  description = "RDS instance endpoint"
  value = module.web_app_db.db_instance_address
}

output "db_instance_id" {
  description = "RDS instance ID"
  value = module.web_app_db.db_instance_identifier
}

output "db_instance_port" {
  description = "RDS instance port"
  value = module.web_app_db.db_instance_port
}

output "db_instance_arn" {
  description = "RDS instance ARN"
  value = module.web_app_db.db_instance_arn
}