variable "name_prefix" {
  description = "Name prefix for the resources"
  type        = string
}

variable "email_address" {
  description = "Email address to send notifications to"
  type        = string
}

variable "spring_boot_app_asg_name" {
  description = "Name of the Spring Boot App Auto Scaling Group"
  type        = string
}

variable "alb_arn_suffix" {
  description = "ARN suffix of the ALB"
  type        = string
}

variable "spring_boot_app_target_group_arn" {
  description = "ARN of the Spring Boot App Target Group"
  type        = string
}

variable "common_tags" {
  description = "Common tags to be applied to the resources"
  type        = map(string)
}

variable "spring_boot_endpoint_url" {
  description = "URL of the Spring Boot App"
  type        = string
}

