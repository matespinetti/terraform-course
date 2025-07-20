# Bastion Host
module "ec2_bastion_host" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.0.2"

  name = "${var.name_prefix}-bastion-host"
  ami = var.ami_id
  instance_type = var.bastion_host_instance_type

  # Network configuration
  subnet_id = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.public_bastion_sg_id]
  create_eip = true

  user_data = file("${path.module}/scripts/jumpbox-install.sh")

  user_data_replace_on_change = true
  # Security and access
  key_name = var.bastion_host_key_pair_name
  tags = var.common_tags
}

# Private App1 Servers
module "ec2_private_app1_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.0.2"

  for_each = var.private_instances1

  name = each.value.instance_name
  ami = var.ami_id
  instance_type = var.private_app_instance_type

  # Network configuration
  subnet_id = each.value.subnet_id
  vpc_security_group_ids = [var.private_app_sg_id]
  associate_public_ip_address = false

  # Security and access
  key_name = var.private_app_instance_key_pair_name

  # User data
  user_data = file("${path.module}/scripts/app1-install.sh")

  tags = var.common_tags

  user_data_replace_on_change = true
  
  # Ensure NAT gateway is ready for package installation
  depends_on = [var.vpc_ready]
}

# Private App2 Servers
module "ec2_private_app2_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.0.2"

  for_each = var.private_instances2

  name = each.value.instance_name
  ami = var.ami_id
  instance_type = var.private_app_instance_type

  # Network configuration
  subnet_id = each.value.subnet_id
  vpc_security_group_ids = [var.private_app_sg_id]
  associate_public_ip_address = false

  # Security and access
  key_name = var.private_app_instance_key_pair_name

  # User data
  user_data = file("${path.module}/scripts/app2-install.sh")

  tags = var.common_tags

  user_data_replace_on_change = true
  
  # Ensure NAT gateway is ready for package installation
  depends_on = [var.vpc_ready]
}

module "ec2_private_spring_boot_app_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.0.2"

  for_each = var.private_instances_spring_boot_app

  name = each.value.instance_name
  ami = var.ami_id
  instance_type = var.private_app_instance_type

  # Network configuration
  subnet_id = each.value.subnet_id
  vpc_security_group_ids = [var.spring_boot_app_sg_id]
  associate_public_ip_address = false

  # Security and access
  key_name = var.private_app_instance_key_pair_name

  # User data
  user_data = templatefile("${path.module}/scripts/spring-boot-app-install.tmpl", {
    rds_db_endpoint = var.web_app_db_endpoint
    rds_db_port = var.web_app_db_port
    rds_db_name = var.web_app_db_name
    rds_db_username = var.web_app_db_username
    rds_db_password = var.web_app_db_password
  })

  tags = var.common_tags

  user_data_replace_on_change = true

  depends_on = [var.vpc_ready]
}

# Bastion Host Setup
resource "null_resource" "bastion_host_setup" {
  triggers = {
    bastion_host_id = module.ec2_bastion_host.id
  }

  connection {
    type = "ssh"
    host = module.ec2_bastion_host.public_ip
    user = "ec2-user"
    private_key = var.private_key_content
  }
  
  provisioner "file" {
    content = var.private_key_content
    destination = "/tmp/${var.bastion_host_key_pair_name}.pem"
  }
  
  provisioner "remote-exec" {
    inline = [
      "chmod 400 /tmp/${var.bastion_host_key_pair_name}.pem",
    ]
  }
}