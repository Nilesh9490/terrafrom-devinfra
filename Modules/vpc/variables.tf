## Provide the Default availabilty zones values
variable "az_names" {
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b" , "eu-west-2c"]
  description = "List of availablity zones"
}

## Provide the Default Public Subnets
variable "public_subnet_values" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24" , "10.0.3.0/24"]
  description = "List of public subnets"
}

## Provide the Default Private Subnets
variable "private_subnet_values" {
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  description = "List of private subnets"
}

## Provide the Default Database Subnets
variable "database_subnet_values" {
  type        = list(string)
  default     = ["10.0.7.0/24", "10.0.8.0/24"]
  description = "List of Database subnets"
}

## Provide the Default Project name for tag value
variable "project_name_tag" {
  type        = string
  default     = "Testproject"
  description = "This is the tag value which you want to specify for Project"
}

## Provide the Default CIDR value for VPC
variable "cidr_value" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR value for VPC setup"
}

## Provide the Default Project Name
variable "project_name" {
  type        = string
  default     = "Testproject-Prod"
  description = "This is the Project Name which you want to setup"
}

