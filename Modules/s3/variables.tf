# variable "s3_bucket_name" {}
# variable "static_assets_directory" {}

variable "s3_bucket_name" {
    type = string
    default = "s3bucket-test"
}

variable "static_assets_directory" {
    type = string
    default = "/Users/macbook11/Documents/work/DevOps/Terraform/frontend-deployment/build/"
    description = "Absolute path of the code directory"
}
