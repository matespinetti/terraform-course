variable "db_instance_identifier" {
  description = "RDS DB Instance Identifier"
  type = string
}

variable "db_instance_class" {
  description = "RDS DB Instance Class"
  type = string
  default = "db.t3.micro"
}

variable "db_name" {
  description = "RDS DB Name"
  type = string
}

variable "db_username" {
  description = "RDS DB Username"
  type = string
}

variable "db_password" {
  description = "RDS DB Password"
  type = string
  sensitive = true
}

variable "db_port" {
  description = "RDS DB Port"
  type = string
  default = "3306"
}

variable "database_subnet_group_name" {
  description = "Database subnet group name"
  type = string
}

variable "rds_sg_id" {
  description = "RDS security group ID"
  type = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type = map(string)
  default = {}
}