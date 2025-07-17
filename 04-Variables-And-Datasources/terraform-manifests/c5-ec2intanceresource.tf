resource "aws_instance" "myec2vm" {
    ami = data.aws_ami.amazon_linux_2023.id
    instance_type = var.instance_type
    user_data = file("${path.module}/app1-install.sh")
    key_name = var.instance_key_pair
    vpc_security_group_ids = [aws_security_group.ssh_sg.id, aws_security_group.web_sg.id]
    tags = {
        Name = "My EC2 VM"
    }
  
}