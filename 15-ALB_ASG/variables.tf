# GLOBAL VARIABLES
variable "aws_region" {
    description = "Region in which the VPC will be created"
    type = string
    default = "us-east-1"
}

variable "environment" {
    description = "Environment in which the VPC will be created"
    type = string
    default = "dev"
    validation {
        condition = contains(["dev", "qa", "prod"], var.environment)
        error_message = "Environment must be one of dev, qa, prod"
    }
}

variable "business_division" {
    description = "Business division in which the VPC will be created"
    type = string
    default = "hr"
    validation {
        condition = contains(["hr", "finance", "it"], var.business_division)
        error_message = "Business division must be one of hr, finance, it"
    }
}

# VPC VARIABLES
variable "vpc_name" {
  description = "VPC Name"
  type = string
  default = "vpc-dev"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR"
  type = string
  default = "10.0.0.0/16"
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type = bool
  default = true
}

variable "single_nat_gateway" {
  description = "Single NAT Gateway"
  type = bool
  default = true
}

variable "create_database_subnet_group" {
  description = "Create Database Subnet Group"
  type = bool
  default = true
}

variable "create_database_subnet_route_table" {
  description = "Create Database Subnet Route Table"
  type = bool
  default = true
}

# EC2 VARIABLES
variable "bastion_host_instance_type" {
  description = "Instance Type for Bastion Host"
  type = string
  default = "t3.micro"
}

variable "bastion_host_key_pair_name" {
  description = "Key Pair Name for Bastion Host"
  type = string
  default = "terraform-key1"
}

variable "private_app_instance_count" {
  description = "Number of Private App Instances"
  type = number
  default = 1
}

variable "private_app_instance_key_pair_name" {
  description = "Key Pair Name for Private App Instances"
  type = string
  default = "terraform-key1"
}

variable "private_app_instance_type" {
  description = "Instance Type for Private App"
  type = string
  default = "t3.micro"
}

variable "domain_name" {
  description = "Domain Name"
  type = string
  default = "matespinetti.me"
}



# RDS VARIABLES
variable "web_app_db_name" {
  description = "RDS DB Name"
  type = string
  default = "webappdb"
}

variable "web_app_db_instance_identifier" {
  description = "RDS DB Instance Identifier"
  type = string
  default = "webapp-db-dev"
}

variable "web_app_db_instance_class" {
  description = "RDS DB Instance Class"
  type = string
  default = "db.t3.micro"
}

variable "web_app_db_username" {
  description = "RDS DB Username"
  type = string
  default = "dbadmin"
}

variable "web_app_db_port" {
  description = "RDS DB Port"
  type = string
  default = "3306"
}

variable "web_app_db_password" {
  description = "RDS DB Password"
  type = string
  default = "YourPassword123!"
  sensitive = true
}


# NOTIFICATIONS VARIABLES
variable "email_address" {
  description = "Email address to send notifications to"
  type = string
  default = "mateus.pinetti@gmail.com"
}