variable "aws_region" {
    description = "Region in which the VPC will be created"
    type = string
    default = "us-east-1"
}

#Environment variable
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