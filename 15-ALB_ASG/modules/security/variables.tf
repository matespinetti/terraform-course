variable "name_prefix" {
  description = "Name prefix for security group resources"
  type = string
}

variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type = map(string)
  default = {}
}