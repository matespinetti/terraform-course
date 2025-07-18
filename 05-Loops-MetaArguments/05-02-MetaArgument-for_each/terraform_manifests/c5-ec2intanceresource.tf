
data "aws_availability_zones" "my_azs" {
    state = "available"  
}


data "aws_ec2_instance_type_offerings" "instance_type_offerings" {
    filter {
      name = "instance-type"
      values = [var.instance_type_map["dev"]]
    }
    location_type = "availability-zone"
}

locals {
  instance_available_azs = toset(data.aws_ec2_instance_type_offerings.instance_type_offerings.locations)
  compatible_azs = toset([
    for az in data.aws_availability_zones.my_azs.names : 
    az if contains(local.instance_available_azs, az)
  ])
}

resource "aws_instance" "myec2vm" {
    for_each = local.compatible_azs 
    ami = data.aws_ami.amazon_linux_2023.id
    # instance_type = var.instance_type # This is the value for the key "dev" in the map
    # instance_type = var.instance_type_list[0] # This is the first item in the list
    instance_type = var.instance_type_map["dev"] # This is the value for the key "dev" in the map
    user_data = file("${path.module}/app1-install.sh")
    key_name = var.instance_key_pair
    vpc_security_group_ids = [aws_security_group.ssh_sg.id, aws_security_group.web_sg.id]
    # For each can only be used with sets and maps.
    tags = {
        Name = "For-Each-Demo-${each.value}" # each.key is equal to each.value in sets.
    }
  
}