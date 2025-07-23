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


# Spring Boot App Auto Scaling Group and Launch Template
module "spring_boot_app_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "9.0.1"

  name = "${var.name_prefix}-spring-boot-app-asg"

  ignore_desired_capacity_changes = true

  min_size = var.spring_boot_app_asg_min_size
  max_size = var.spring_boot_app_asg_max_size
  desired_capacity = var.spring_boot_app_asg_desired_capacity
  wait_for_capacity_timeout = 0
  health_check_type = "ELB"
  vpc_zone_identifier = var.private_subnet_ids


  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  # Traffic Source Attachment
  traffic_source_attachments = {
    alb_tg_attachment = {
      traffic_source_identifier = var.spring_boot_app_target_group_arn
      traffic_source_type = "elbv2"
    }
  }


  # Launch Template
  launch_template_name = "${var.name_prefix}-spring-boot-app-launch-template"
  launch_template_description = "Spring Boot App Launch Template"
  image_id = var.ami_id
  instance_type = var.private_app_instance_type
  security_groups = [var.spring_boot_app_sg_id]
  key_name = var.private_app_instance_key_pair_name
  ebs_optimized = true
  enable_monitoring = true
  update_default_version = true
  block_device_mappings = [
     {
      device_name = "/dev/xvda"
      no_device = 0
      ebs = {
        volume_size = 30
        volume_type = "gp3"
        encrypted = true
        delete_on_termination = true
      }
    }
  ]
  user_data = base64encode(templatefile("${path.module}/scripts/spring-boot-app-install.tmpl", {
    rds_db_endpoint = var.web_app_db_endpoint
    rds_db_port = var.web_app_db_port
    rds_db_name = var.web_app_db_name
    rds_db_username = var.web_app_db_username
    rds_db_password = var.web_app_db_password
  }))

 

    
  #Policies
  scaling_policies = {
    avg_cpu_policy_greater_than_75 = {
      name = "${var.name_prefix}-avg-cpu-policy-greater-than-75"
      policy_type = "TargetTrackingScaling"
      policy_name = "${var.name_prefix}-avg-cpu-policy-greater-than-75"
      estimated_instance_warmup = 300
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 75
      
      }
     
    }
    request_count_per_target_target_800 = {
      policy_type = "TargetTrackingScaling"
      name = "${var.name_prefix}-request-count-per-target-target-800"
      estimated_instance_warmup = 300
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "RequestCountPerTarget"
        }
        target_value = 800
      }
      
    }

  
  }
   #Tags
  tags = var.common_tags

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