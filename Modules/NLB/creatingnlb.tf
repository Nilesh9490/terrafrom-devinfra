resource "aws_lb" "nlb" {
  name               = "${terraform.workspace}-alb"
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id            = element(var.private_subnets, 0)
    # private_ipv4_address = "10.0.1.15"
  }

  subnet_mapping {
    subnet_id            = element(var.private_subnets, 1)
    # private_ipv4_address = "10.0.2.15"
  }

  subnet_mapping {
    subnet_id            = element(var.private_subnets, 2)
    # private_ipv4_address = "10.0.2.15"
  }
}
resource "aws_lb_target_group" "ip-target" {
  name        = "tf-example-lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}


resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "443"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ip-target.arn
  }
}

output "lb_arn" {
  value = aws_lb.nlb.arn 
}