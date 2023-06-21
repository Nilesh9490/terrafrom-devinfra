variable "vpc_id" {
  description = "VPC ID"
}

variable "public_subnets" {
  description = "public subnet IDs"
  type        = list(string)
}
variable "private_subnets" {
  description = "private subnet IDs"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"
}

variable "eks_version" {
  description = "Version of Kubernetes for the EKS cluster"
  type        = string
  default     = "1.27"
}

variable "node_group_name" {
    description = "name of worker node group"
    type = string
    default = "worker_node"
}

variable "eks_cluster_role_name" {
    description = "name of role for eks cluster"
    type = string
    default = "EKScluster_role"
  
}