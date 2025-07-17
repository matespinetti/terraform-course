terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

# Provider block
provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "ec2demo" {
    ami = "ami-0150ccaf51ab55a51"
    instance_type = "t2.micro"
    tags = {
        Name = "ec2demo"
    }
}