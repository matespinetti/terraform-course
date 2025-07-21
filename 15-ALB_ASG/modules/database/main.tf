module "web_app_db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.12.0"
  
  identifier = var.db_instance_identifier
  
  # Engine 
  engine = "mysql"
  engine_version = "8.0.33"
  family = "mysql8.0" 
  major_engine_version = "8.0"
  instance_class = var.db_instance_class

  # Storage
  allocated_storage = 20
  max_allocated_storage = 50

  # Authentication
  db_name = var.db_name
  username = var.db_username
  password = var.db_password
  manage_master_user_password = false
  port = var.db_port

  # Database Configuration
  multi_az = false
  db_subnet_group_name = var.database_subnet_group_name
  vpc_security_group_ids = [var.rds_sg_id]

  # Maintenance and Backup
  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["general"]
  create_cloudwatch_log_group     = true

  # Snapshot
  skip_final_snapshot = true
  deletion_protection = false

  # Parameters
  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  # Tags
  tags = var.common_tags
}