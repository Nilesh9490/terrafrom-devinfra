# resource "aws_key_pair" "ssh_key_name" {
#   key_name   = "${terraform.workspace}-ssh_key"
#   public_key = file(var.PATH_TO_PUBLIC_KEY)
# }

resource "aws_instance" "ec2" {
  count  = length(var.instance_names)
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = var.instance_type
  subnet_id     = element(var.private_subnets, 0)
  # key_name                    = aws_key_pair.ssh_key_name.key_name
  iam_instance_profile        = "${terraform.workspace}-ram_metrix_role"
  user_data = file("Script/install.sh")
  security_groups             = [var.security_group_id]
  associate_public_ip_address = true

  ebs_block_device {
    device_name = "${terraform.workspace}-${var.ebs_names[count.index]}"
    volume_size = var.ebs_block_device_size
  }

  tags = {
    
    # Name = "$(terraform.workspace)-${var.instance_names[count.index]}"  
    Name = "${terraform.workspace}-${var.instance_names[count.index]}"
  }

  # connection {
  #   host        = coalesce(self.public_ip)
  #   type        = "ssh"
  #   user        = var.INSTANCE_USERNAME
  #   private_key = file(var.PATH_TO_PRIVATE_KEY)
  #   timeout     = "1m"
  # }


  # provisioner "file" {
  #   source      = "Script/install.sh"
  #   destination = "/tmp/install.sh"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod +x /tmp/install.sh",
  #     "sudo sed -i -e 's/\r$//' /tmp/install.sh", # Remove the spurious CR characters.
  #     "sudo /tmp/install.sh",
  #   ]
  # }

}
