resource "aws_instance" "myec2vm" {
    ami = "ami-0150ccaf51ab55a51"
    instance_type = "t2.micro"
    user_data = file("${path.module}/app1-install.sh") # This is the user data that is used to install the application on the EC2 instance.
    tags = {
      "Name" = "myec2vm"
    }

}