

# variable "public_subnets" {
#   description = "public subnet IDs"
#   type        = list(string)
# }

variable "private_subnets" {
  description = "private subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
}