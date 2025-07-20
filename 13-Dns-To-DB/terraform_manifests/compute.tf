#Bastion Host
module "ec2_bastion_host" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.0.2"

  name = "${local.name}-bastion-host"
  ami = local.amazon_linux_2023_ami_id
  instance_type = var.bastion_host_instance_type

  #Network configuration
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.public_bastion_sg.security_group_id]
  create_eip = true #Create an Elastic IP for the bastion host

  #Security and access
  key_name = var.bastion_host_key_pair_name
  tags = local.common_tags




}

module "ec2_private_app1_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.0.2"

  for_each = local.private_instances1

  name = each.value.instance_name
  ami = local.amazon_linux_2023_ami_id
  instance_type = var.private_app_instance_type

  #Network configuration
  subnet_id = each.value.subnet_id
  vpc_security_group_ids = [module.private_app_sg.security_group_id]
  associate_public_ip_address = false


  #Security and access
  key_name = var.private_app_instance_key_pair_name

  #User data
  user_data = file("${path.module}/scripts/app1-install.sh")

  tags = local.common_tags

  depends_on = [ module.vpc ]
}


module "ec2_private_app2_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.0.2"

  for_each = local.private_instances2

  name = each.value.instance_name
  ami = local.amazon_linux_2023_ami_id
  instance_type = var.private_app_instance_type

  #Network configuration
  subnet_id = each.value.subnet_id
  vpc_security_group_ids = [module.private_app_sg.security_group_id]
  associate_public_ip_address = false

  #Security and access
  key_name = var.private_app_instance_key_pair_name

  #User data
  user_data = file("${path.module}/scripts/app2-install.sh")

  tags = local.common_tags

  depends_on = [ module.vpc ]
}