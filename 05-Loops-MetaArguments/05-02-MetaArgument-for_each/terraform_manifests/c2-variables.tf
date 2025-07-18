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

variable "instace_type_list" {
    description = "EC2 instance type list"
    type = list(string)
    default = ["t2.micro", "t3.micro"]
  
}

variable "instance_type_map" {
    description = "EC2 instance type map"
    type = map(string)
    default = {
      "dev" = "t3.micro",
      "qa" = "t3.micro"
      "prod" = "t3.large"
    }
  
}