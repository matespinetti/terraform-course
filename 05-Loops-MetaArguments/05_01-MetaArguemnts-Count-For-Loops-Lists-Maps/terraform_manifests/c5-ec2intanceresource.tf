resource "aws_instance" "myec2vm" {
    ami = data.aws_ami.amazon_linux_2023.id
    # instance_type = var.instance_type # This is the value for the key "dev" in the map
    # instance_type = var.instance_type_list[0] # This is the first item in the list
    instance_type = var.instance_type_map["dev"] # This is the value for the key "dev" in the map
    user_data = file("${path.module}/app1-install.sh")
    key_name = var.instance_key_pair
    vpc_security_group_ids = [aws_security_group.ssh_sg.id, aws_security_group.web_sg.id]
    count = 2
    tags = {
        Name = "Count-Demo-${count.index + 1}"
    }
  
}