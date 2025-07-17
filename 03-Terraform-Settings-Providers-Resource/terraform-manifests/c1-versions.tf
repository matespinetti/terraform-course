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
  region = "us-east-1"
  profile = "default" # This is the profile that is used to authenticate with AWS.

}
