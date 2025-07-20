variable "alb_name" {
  description = "Name for the Application Load Balancer"
  type = string
}

variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "alb_subnets" {
  description = "List of subnet IDs for ALB"
  type = list(string)
}

variable "alb_sg_id" {
  description = "Security group ID for ALB"
  type = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN"
  type = string
}


variable "domain_name" {
  description = "Domain name"
  type = string
}

variable "app1_instances" {
  description = "Map of app1 instance details"
  type = map(object({
    id = string
  }))
}

variable "app2_instances" {
  description = "Map of app2 instance details"
  type = map(object({
    id = string
  }))
}

variable "spring_boot_app_instances" {
  description = "Map of spring boot app instance details"
  type = map(object({
    id = string
  }))
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type = map(string)
  default = {}
}

