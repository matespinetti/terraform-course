output "vpc_id" {
  description = "ID of the VPC"
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value = module.vpc.vpc_cidr_block
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value = module.vpc.private_subnets
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value = module.vpc.database_subnets
}

output "database_subnet_group" {
  description = "ID of database subnet group"
  value = module.vpc.database_subnet_group
}

output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value = module.vpc.azs
}