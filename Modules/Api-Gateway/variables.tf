variable "access_key" {
  description = "Access Key Id -> set TF_VAR_aws_access"
  default     = ""
}

variable "secret_key" {
  description = "Access Secret -> set TF_VAR_aws_secret"
  default     = ""
}

# variable "account_id" {
#   description = "Account Id -> set TF_VAR_account_id"
#   default     = ""
# }

variable "region" {
  description = "Region -> set TF_VAR_account_id"
  default     = "us-east-1"
}

variable "lb_arn" {
  description = "arn fron nlb module"
}

variable "env-name" {
  description = "env-name"
  default     = "prod"
}
