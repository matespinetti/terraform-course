variable "aws_region" {
    description = "Region in which AWS resources are to be created"
    type = string
    default = "us-east-1"
  
}

variable "instance_type" {
    description = "EC2 instance type"
    type = string
    default = "t2.micro"
  
}

variable "instance_key_pair" {
    description = "AWS EC2 Instance Key Pair"
    type = string 
    default = "terraform-key1"

}