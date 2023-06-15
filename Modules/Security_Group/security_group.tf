#Security Group 
resource "aws_security_group" "dev-callahan-marketplace" {
  vpc_id      = var.vpc_id
  name        = var.security_groups
  description = "security group that allows ssh connection"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = var.tag
  }
}


output "security_group_id" {
  value = aws_security_group.dev-callahan-marketplace.id
}

