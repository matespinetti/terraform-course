terraform {
  required_version = "~> 1.12"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.3.0"

    }
  }
}

provider "aws" {
  region = var.aws_region
  profile = "default" # This is the profile that is used to authenticate with AWS.

}
