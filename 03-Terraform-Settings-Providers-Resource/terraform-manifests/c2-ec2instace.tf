resource "aws_instance" "myec2vm" {
    ami = "ami-0150ccaf51ab55a51"
    instance_type = "t2.micro"
    user_data = file("${path.module}/app1-install.sh")
    tags = {
      "Name" = "myec2vm"
    }

  
}