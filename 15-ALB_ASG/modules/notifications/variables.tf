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