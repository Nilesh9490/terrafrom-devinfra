resource "aws_security_group" "elasticsg" {
  name        = "${terraform.workspace}-opensearch-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticsearch_domain" "es" {
  # domain_name           = var.aws_elasticsearch_domain_name
  domain_name = "${terraform.workspace}-search"
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type          = var.instance_type
  }

  vpc_options {
   
    subnet_ids  = [element(var.private_subnets, 0)]
    security_group_ids = [aws_security_group.elasticsg.id]
    
  }

  ebs_options {
    ebs_enabled = true
    volume_type = var.ebs_options_volume_type
    volume_size = var.ebs_options_volume_size
  }

  tags = {
    # Name = var.tag_name
    Name = "${terraform.workspace}-opensearch"
     }
}