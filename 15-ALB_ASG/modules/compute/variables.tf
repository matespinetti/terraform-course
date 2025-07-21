# ==============================================================================
# GENERAL VARIABLES
# ==============================================================================
variable "name_prefix" {
  description = "Name prefix for compute resources"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# ==============================================================================
# NETWORK VARIABLES
# ==============================================================================
variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "vpc_ready" {
  description = "Dependency to ensure VPC and NAT gateway are ready"
  type        = any
  default     = null
}

# ==============================================================================
# SECURITY GROUP VARIABLES
# ==============================================================================
variable "public_bastion_sg_id" {
  description = "Security group ID for bastion host"
  type        = string
}

variable "private_app_sg_id" {
  description = "Security group ID for private app instances"
  type        = string
}

variable "spring_boot_app_sg_id" {
  description = "Security group ID for spring boot app instances"
  type        = string
}

# ==============================================================================
# BASTION HOST VARIABLES
# ==============================================================================
variable "bastion_host_instance_type" {
  description = "Instance Type for Bastion Host"
  type        = string
  default     = "t3.micro"
}

variable "bastion_host_key_pair_name" {
  description = "Key Pair Name for Bastion Host"
  type        = string
}

variable "private_key_content" {
  description = "Content of the private key file"
  type        = string
  sensitive   = true
}

# ==============================================================================
# PRIVATE APP INSTANCES VARIABLES
# ==============================================================================
variable "private_app_instance_type" {
  description = "Instance Type for Private App"
  type        = string
  default     = "t3.micro"
}

variable "private_app_instance_key_pair_name" {
  description = "Key Pair Name for Private App Instances"
  type        = string
}



variable "private_instances_spring_boot_app" {
  description = "Map of private spring boot app instances"
  type = map(object({
    subnet_id     = string
    instance_name = string
  }))
}

# ==============================================================================
# SPRING BOOT ASG VARIABLES
# ==============================================================================
variable "spring_boot_app_asg_min_size" {
  description = "Minimum number of spring boot app instances"
  type        = number
  default     = 1
}

variable "spring_boot_app_asg_max_size" {
  description = "Maximum number of spring boot app instances"
  type        = number
  default     = 3
}

variable "spring_boot_app_asg_desired_capacity" {
  description = "Desired number of spring boot app instances"
  type        = number
  default     = 1
}
# ==============================================================================
# DATABASE CONNECTION VARIABLES
# ==============================================================================
variable "web_app_db_endpoint" {
  description = "Endpoint of the web app database"
  type        = string
}

variable "web_app_db_port" {
  description = "Port of the web app database"
  type        = string
}

variable "web_app_db_name" {
  description = "Name of the web app database"
  type        = string
}

variable "web_app_db_username" {
  description = "Username of the web app database"
  type        = string
}

variable "web_app_db_password" {
  description = "Password of the web app database"
  type        = string
  sensitive   = true
}