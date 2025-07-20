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

output "private_app1_instances" {
  description = "Map of private app1 instance details"
  value = {
    for k, v in module.ec2_private_app1_server : k => {
      id = v.id
      private_ip = v.private_ip
      availability_zone = v.availability_zone
    }
  }
}

output "private_app2_instances" {
  description = "Map of private app2 instance details"
  value = {
    for k, v in module.ec2_private_app2_server : k => {
      id = v.id
      private_ip = v.private_ip
      availability_zone = v.availability_zone
    }
  }
}

output "private_spring_boot_app_instances" {
  description = "Map of private spring boot app instance details"
  value = {
    for k, v in module.ec2_private_spring_boot_app_server : k => {
      id = v.id
      private_ip = v.private_ip
      availability_zone = v.availability_zone
    }
  }
}