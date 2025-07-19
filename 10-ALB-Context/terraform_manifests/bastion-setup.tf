resource "null_resource" "bastion_host_setup" {
   
    triggers = {
      bastion_host_id = module.ec2_bastion_host.id
    }

    connection {
      type = "ssh"
      host = module.ec2_bastion_host.public_ip
      user = "ec2-user"
      private_key = file("${path.module}/private-key/terraform-key-mac.pem") 

    }
    provisioner "file" {
        source = "${path.module}/private-key/terraform-key-mac.pem"
        destination = "/tmp/terraform-key-mac.pem"
      
    }
    provisioner "remote-exec" {
        inline = [
            "chmod 400 /tmp/terraform-key-mac.pem",
        ]
    }
  
}