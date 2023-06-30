variable "vpc_id" {
  description = "VPC ID"
}

# variable "public_subnets" {
#   description = "public subnet IDs"
#   type        = list(string)
# }
variable "private_subnets" {
  description = "private subnet IDs"
  type        = list(string)
}

variable "eks_version" {
  description = "Version of Kubernetes for the EKS cluster"
  type        = string
  default     = "1.27"
}

# variable "security_group_id" {
#   description = "ID of the security group to associate with the instance"
# }

# variable "availability_zone_az1" {
#   description = "Availability Zone for subnet in Availability Zone 1"
#   type        = string
# #   default     = "us-west-2a"
# }

# variable "availability_zone_az2" {
#   description = "Availability Zone for subnet in Availability Zone 2"
#   type        = string
#   default     = "us-west-2b"
# }

# variable "cluster_name" {
#   description = "Name of the EKS cluster"
#   type        = string
#   default     = "my-eks-cluster"
# }

# variable "node_group_name" {
#     description = "name of worker node group"
#     type = string
#     default = "worker_node"
# }

# variable "eks_cluster_role_name" {
#     description = "name of role for eks cluster"
#     type = string
#     default = "EKScluster_role"
# }