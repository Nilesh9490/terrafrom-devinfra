resource "aws_eks_cluster" "eks_cluster" {
  name            = "${terraform.workspace}-eks"
  role_arn        = aws_iam_role.eks_cluster_role.arn
  version         = var.eks_version
  vpc_config {
    subnet_ids = var.private_subnets
    endpoint_private_access = true
    endpoint_public_access  = true
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "${terraform.workspace}-eksrole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${terraform.workspace}-workernodes"
  node_role_arn   = aws_iam_role.eks_node_role.arn
    subnet_ids = var.private_subnets
  instance_types = ["t2.micro"]
  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 1
  }
}

resource "aws_iam_role" "eks_node_role" {
  name = "${terraform.workspace}-eks_node_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks_node_role_policy_attachment" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_node_role_policy_attachment_ecr" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

output "eks_cluster" {
  value = aws_eks_cluster.eks_cluster.id
}

output "eks_node_group" {
  value = aws_eks_node_group.eks_node_group.id
}
