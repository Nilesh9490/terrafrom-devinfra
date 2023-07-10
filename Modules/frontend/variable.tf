
# variable "s3_bucket_name" {
#     type = string
#     default = "s3bucket-testdemoo"
# }
variable "s3_bucket_name" {
  type    = list(string)
  default = ["dev-qwertyuiop-s3", "qa-qwertyuiop-s3"]
}
variable "static_assets_directory" {
    type = string
    default = "index.html"
    description = "Absolute path of the code directory"
}



variable "default_root_object" {
    type = string
    default = "index.html"
}

variable "origin_path" {
    type = string
    default = "/"
}
variable "cloudfront_description" {
    type = string
    default = "automation-cloudfront"
    description = "Cloudfront Description"
}