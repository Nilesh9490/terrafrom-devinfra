locals {
  mime_types = {
    "css"  = "text/css"
    "html" = "text/html"
    "ico"  = "image/vnd.microsoft.icon"
    "js"   = "application/javascript"
    "json" = "application/json"
    "map"  = "application/json"
    "png"  = "image/png"
    "svg"  = "image/svg+xml"
    "txt"  = "text/plain"
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = var.s3_bucket_name
#   comment = "${terraform.workspace}-s3bucketname"
}

resource "aws_s3_bucket" "s3Bucket" {
  depends_on = [aws_cloudfront_origin_access_identity.origin_access_identity]  

  bucket = var.s3_bucket_name
#   bucket = "${terraform.workspace}-s3bucketname"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Sid":"1",
      "Principal": {
        "AWS": ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
      },
      "Action": [ "s3:GetObject" ],
      
      "Resource":["arn:aws:s3:::${var.s3_bucket_name}/*"]
    }
  ]
}
EOF
}
##line number 37 ##"Resource":["arn:aws:s3:::${var.s3_bucket_name}/*"]
######"Resource":["arn:aws:s3:::${terraform.workspace}-s3bucketname/*"]
resource "aws_s3_bucket_public_access_block" "accessBlock" {
  depends_on = [aws_s3_bucket.s3Bucket]

  bucket = aws_s3_bucket.s3Bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "dist" {
  depends_on = [aws_s3_bucket.s3Bucket]

  for_each      = fileset("${var.static_assets_directory}", "*")
  bucket        = var.s3_bucket_name
#   bucket = "${terraform.workspace}-s3bucketname"
  key           = each.value
  source        = "${var.static_assets_directory}${each.value}"
  etag          = filemd5("${var.static_assets_directory}${each.value}")
  content_type  = lookup(tomap(local.mime_types), element(split(".", each.key), length(split(".", each.key)) - 1))
}

# output "aws_s3_bucket_name" {
#   value = aws_s3_bucket.s3Bucket.bucket
# }

# output "aws_cloudfront_origin_access_identity_id" {
#   value = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
# }

# output "aws_s3_bucket_regional_domain_name" {
#   value = aws_s3_bucket.s3Bucket.bucket_regional_domain_name
# }

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.s3Bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.s3Bucket.bucket

    # origin_path = var.origin_path

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
}
    }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.cloudfront_description
  default_root_object = var.default_root_object
   
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.s3Bucket.bucket

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# to get the Cloud front URL if doamin/alias is not configured
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}


# output "cloudfront_endpoint" {
#   value       = module.cloudfront[0].cloudfront_domain_name
#   description = "Cloudfront public dns of the website."
# }