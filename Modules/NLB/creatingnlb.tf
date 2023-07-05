resource "aws_lb" "nlb" {
  name               = "${terraform.workspace}-alb"
  internal           = false
  load_balancer_type = "network"
  # subnets            = [for subnet in aws_subnet.public : subnet.id]
  subnets = element(var.private_subnets, 0)

  enable_deletion_protection = true

  tags = {
    Environment = "${terraform.workspace}"
  }
}