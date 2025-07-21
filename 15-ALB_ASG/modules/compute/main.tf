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

# Spring Boot App Launch Template
resource "aws_launch_template" "spring_boot_app_launch_template" {
  name = "${var.name_prefix}-spring-boot-app-launch-template"
  image_id = var.ami_id
  instance_type = var.private_app_instance_type
  vpc_security_group_ids = [var.spring_boot_app_sg_id]
  key_name = var.private_app_instance_key_pair_name

  update_default_version = true

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 10
      volume_type = "gp3"
      encrypted = true
      delete_on_termination = true
    }
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
  }

    user_data = templatefile("${path.module}/scripts/spring-boot-app-install.tmpl", {
    name_prefix = var.name_prefix
    rds_db_endpoint = var.web_app_db_endpoint
    rds_db_port = var.web_app_db_port
    rds_db_name = var.web_app_db_name
    rds_db_username = var.web_app_db_username
    rds_db_password = var.web_app_db_password
  })
  
  tag_specifications {
    resource_type = "instance"
    tags = var.common_tags
  }
  
}

# Spring Boot App Auto Scaling Group
module "spring_boot_app_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "9.17.0"

  ignore_desired_capacity_changes = true

  min_size = var.spring_boot_app_asg_min_size
  max_size = var.spring_boot_app_asg_max_size
  desired_capacity = var.spring_boot_app_asg_desired_capacity
  wait_for_capacity_timeout = 0
  health_check_type = "ELB"
  vpc_zone_identifier = var.private_subnet_ids

  # Traffic Source Attachment
  traffic_source_attachments = {
    alb_tg_attachment = {
      target_group_arn = module.alb.target_groups["spring_boot_app_tg"].arn
      traffic_source_arn = module.alb.arn
    }
  }


  # Launch Template
  launch_template_id = aws_launch_template.spring_boot_app_launch_template.id
  vpc_zone_identifier = var.private_subnet_ids

  tags = var.common_tags
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