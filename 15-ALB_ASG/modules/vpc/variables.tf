variable "vpc_name" {
  description = "VPC Name"
  type = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR"
  type = string
}

variable "azs" {
  description = "Availability Zones"
  type = list(string)
}

variable "public_subnets" {
  description = "Public Subnets"
  type = list(string)
}

variable "private_subnets" {
  description = "Private Subnets"
  type = list(string)
}

variable "database_subnets" {
  description = "Database Subnets"
  type = list(string)
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

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames"
  type = bool
  default = true
}

variable "enable_dns_support" {
  description = "Enable DNS support"
  type = bool
  default = true
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type = map(string)
  default = {}
}