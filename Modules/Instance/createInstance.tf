resource "aws_key_pair" "ssh_key_name" {
  key_name   = var.key_name
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "demo-dev" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = var.instance_type
  subnet_id     = element(var.public_subnets, 0)
  key_name                    = aws_key_pair.ssh_key_name.key_name
  iam_instance_profile        = "ram_metrix_role"
  security_groups             = [var.security_group_id]
  associate_public_ip_address = true

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = var.ebs_block_device_size
  }

  tags = {
    Name = var.tag_name
  }

  connection {
    host        = coalesce(self.public_ip)
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
    timeout     = "1m"
  }


  provisioner "file" {
    source      = "Script/install.sh"
    destination = "/tmp/install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install.sh",
      "sudo sed -i -e 's/\r$//' /tmp/install.sh", # Remove the spurious CR characters.
      "sudo /tmp/install.sh",
    ]
  }

}
