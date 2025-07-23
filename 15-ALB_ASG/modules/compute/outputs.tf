output "bastion_host_id" {
  description = "ID of the bastion host"
  value = module.ec2_bastion_host.id
}

output "bastion_host_public_ip" {
  description = "Public IP of the bastion host"
  value = module.ec2_bastion_host.public_ip
}

output "bastion_host_eip" {
  description = "Elastic IP of the bastion host"
  value = module.ec2_bastion_host.public_ip
}

output "spring_boot_asg_name" {
  description = "Name of the Spring Boot App Auto Scaling Group"
  value = module.spring_boot_app_asg.autoscaling_group_name
}

output "spring_boot_asg_arn" {
  description = "ARN of the Spring Boot App Auto Scaling Group"
  value = module.spring_boot_app_asg.autoscaling_group_arn
}

output "spring_boot_asg_id" {
  description = "ID of the Spring Boot App Auto Scaling Group"
  value = module.spring_boot_app_asg.autoscaling_group_id
}

output "spring_boot_asg_launch_template_id" {
  description = "ID of the Spring Boot App Auto Scaling Group Launch Template"
  value = module.spring_boot_app_asg.launch_template_id
}

output "spring_boot_asg_launch_template_arn" {
  description = "ARN of the Spring Boot App Auto Scaling Group Launch Template"
  value = module.spring_boot_app_asg.launch_template_arn
}

output "spring_boot_asg_launch_template_latest_version" {
  description = "Latest version of the Spring Boot App Auto Scaling Group Launch Template"
  value = module.spring_boot_app_asg.launch_template_latest_version
}

output "spring_boot_asg_launch_template_default_version" {
  description = "Default version of the Spring Boot App Auto Scaling Group Launch Template"
  value = module.spring_boot_app_asg.launch_template_default_version
}