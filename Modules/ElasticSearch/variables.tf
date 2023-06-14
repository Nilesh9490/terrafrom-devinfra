variable "aws_security_group_name" {
  type = string
  description = "SG name for elastic search"
  default = "elastic-security-group"
}

variable "aws_elasticsearch_domain_name" {
  type = string
  description = "Domain name for elastic search"
  default = "demotest"
}

variable "instance_type" {
  type = string
  description = "Preferred type of instance for cluster"
  default = "t3.medium.elasticsearch"
}

variable "ebs_options_volume_type"{
  default = "gp2"
}
variable "ebs_options_volume_size"{
  default = "10"
}

variable "tag_name"{
  default = "example-opensearch"
}
variable "vpc_id" {
  description = "VPC ID"
}

variable "public_subnets" {
  description = "public subnet IDs"
  type        = list(string)
}