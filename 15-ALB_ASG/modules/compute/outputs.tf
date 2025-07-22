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

