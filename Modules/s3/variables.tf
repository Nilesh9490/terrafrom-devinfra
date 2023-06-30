
# variable "s3_bucket_name" {
#     type = string
#     default = "s3bucket-test"
# }

variable "static_assets_directory" {
    type = string
    default = "index.html"
    description = "Absolute path of the code directory"
}


variable "bucket_names" {
  type    = list(string)
  default = ["dev-bucket", "qa-bucket"]
}