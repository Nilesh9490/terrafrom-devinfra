# variable "key_name" {
# default = "ssh_key"
# }
variable "instance_names" {
  type    = list(string)
  default = ["dev-ec2", "qa-ec2"]
}

variable "ebs_names" {
  type    = list(string)
  default = ["dev-ebs", "qa-ebs"]
}

variable "AWS_REGION" {
default = "eu-west-2"
}

# variable "security_groups"{
#     type = string
#     default = ""
# }

variable "instance_type" {
type = string
default = "t3.medium"
}

variable "ebs_block_device_size"{
  default = "30"
}

# variable "tag_name"{
#   default = "demo-dev"
#   type = string 
# }

variable "AMIS" {
    type = map
    default = {
        eu-west-2 = "ami-0eb260c4d5475b901"
    }
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "ssh_key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "ssh_key.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}

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

variable "security_group_id" {
  description = "ID of the security group to associate with the instance"
}
