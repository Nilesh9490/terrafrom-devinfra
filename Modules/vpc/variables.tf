# variables.tf

variable "cidr_value" {
  description = "The CIDR block for the VPC."
  type        = string
  default = "172.0.0.0/16"
  
}

variable "az_names" {
  description = "A list of availability zone names."
  type        = list(string)
  # az_names = ["us-east-1a", "us-east-1b", "us-east-1c"]
  default = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

variable "public_subnet_values" {
  description = "A list of public subnet CIDR blocks."
  type        = list(string)
  # public_subnet_values = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  default = ["172.0.1.0/24", "172.0.2.0/24", "172.0.3.0/24"]
}

variable "private_subnet_values" {
  description = "A list of private subnet CIDR blocks."
  type        = list(string)
  # private_subnet_values = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  default = ["172.0.11.0/24", "172.0.12.0/24" , "172.0.13.0/24"]
}

# variable "database_subnet_values" {
#   description = "A list of database subnet CIDR blocks."
#   type        = list(string)
#   default = ["172.0.21.0/24", "172.0.22.0/24", "172.0.23.0/24"]
# }


# variable "workspace_name" {
#   description = "Name of the Terraform workspace"
#   type        = string
#   default     = "${terraform.workspace}"
# }

# variable "project_name" {
#   description = "The name of the project."
#   type        = string
#   # default = "${terraform.workspace}"
# }

# variable "project_name_tag" {
#   description = "The project name tag."
#   type        = string
#   # default = "${terraform.workspace}-vpc"
# }
