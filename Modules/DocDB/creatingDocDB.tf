resource "aws_security_group" "service" {
  name        = var.aws_security_group_name
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_docdb_subnet_group" "service" {
  name       = var.aws_docdb_subnet_group
  subnet_ids = var.private_subnets
}

resource "aws_docdb_cluster_instance" "service" {
  count              = 1
  identifier         = var.aws_docdb_cluster_identifier
  cluster_identifier = aws_docdb_cluster.service.id
  instance_class     = var.aws_docdb_cluster_instance_class
}

resource "aws_docdb_cluster" "service" {
  skip_final_snapshot            = true
  db_subnet_group_name           = aws_docdb_subnet_group.service.name
  cluster_identifier             = var.aws_docdb_cluster_identifier
  engine                         = "docdb"
  master_username                = var.master_username
  master_password                = var.master_password
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.service.name
  vpc_security_group_ids         = [aws_security_group.service.id]
}

resource "aws_docdb_cluster_parameter_group" "service" {
  family = var.aws_docdb_cluster_parameter_group_family
  name   = var.aws_docdb_cluster_parameter_group_name

  parameter {
    name  = "tls"
    value = "disabled"
  }
}
