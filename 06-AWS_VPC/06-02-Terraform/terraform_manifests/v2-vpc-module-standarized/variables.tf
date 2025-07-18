# Global Variables
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

# VPC Variables
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

# NAT Gateway Variables
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

# Database Subnet Variables
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