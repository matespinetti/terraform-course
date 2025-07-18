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