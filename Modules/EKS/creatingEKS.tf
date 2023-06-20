
# resource "aws_vpc" "eks_vpc" {
#   cidr_block = var.vpc_cidr_block
# }

# resource "aws_subnet" "eks_subnet_az1" {
#   vpc_id                  = aws_vpc.eks_vpc.id
#   cidr_block              = var.subnet_cidr_block_az1
#   availability_zone       = var.availability_zone_az1
# }

# resource "aws_subnet" "eks_subnet_az2" {
#   vpc_id                  = aws_vpc.eks_vpc.id
#   cidr_block              = var.subnet_cidr_block_az2
#   availability_zone       = var.availability_zone_az2
# }

resource "aws_eks_cluster" "eks_cluster" {
  name            = var.cluster_name
  role_arn        = aws_iam_role.eks_cluster_role.arn
  version         = var.eks_version
  vpc_config {
    subnet_ids = var.private_subnets
    endpoint_private_access = true
    endpoint_public_access  = false
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = var.eks_cluster_role_name

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
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_node_role.arn
#   subnet_ids      = [
#     aws_subnet.eks_subnet_az1.id,
#     aws_subnet.eks_subnet_az2.id
#   ]
    subnet_ids = var.private_subnets
  instance_types = ["t2.micro"]
  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 1
  }
}

resource "aws_iam_role" "eks_node_role" {
  name = "eks_node_role"

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

