terraform {
  required_version = "~> 1.12"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.3.0"

    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.2.3"
    }
  }
}

provider "aws" {
  region = var.aws_region
  profile = "default"
}

