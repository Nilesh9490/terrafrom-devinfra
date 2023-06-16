variable "aws_s3_bucket_name" {}
variable "aws_cloudfront_origin_access_identity_id" {}
variable "aws_s3_bucket_regional_domain_name" {}


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
