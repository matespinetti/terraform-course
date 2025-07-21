variable "domain_name" {
  description = "Domain name"
  type = string
}


variable "alb_dns_name" {
  description = "ALB DNS name"
  type = string
}

variable "alb_zone_id" {
  description = "ALB zone ID"
  type = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type = map(string)
  default = {}
}