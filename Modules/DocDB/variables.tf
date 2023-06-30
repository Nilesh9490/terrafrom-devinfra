
variable "aws_docdb_cluster_instance_class" {
    default = "db.t3.medium"
    description = "choose desired Instance"
}

variable "master_username" {
    default = "creatingdb"
    description = "Username for db cluster/avoid using reserved key words eg. admin"
}

variable "master_password" {
    default = "admin123"
    description = "Password for db cluster"
}

variable "aws_docdb_cluster_parameter_group_family" {
    default = "docdb5.0"
}   

# variable "aws_docdb_cluster_parameter_group_name" {
#     default = "docdbdev"
# }   

# variable "aws_security_group_name" {
#     default = "tf-new-sec-grp"
#     description = "Name of DB-Security-Group"
# }

# variable "aws_docdb_subnet_group"{
#     default = "tf-new-sub-grp"
#     description = "Name of DB-Subnet-Group"
# }

# variable "aws_docdb_cluster_identifier" {
#     default = "tf-identifier"
# }

variable "vpc_id" {
  description = "VPC ID"
}

# variable "public_subnets" {
#   description = "public subnet IDs"
#   type        = list(string)
# }


variable "private_subnets" {
  description = "public subnet IDs"
  type        = list(string)
}

