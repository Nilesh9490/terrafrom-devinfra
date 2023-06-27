
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = var.aws_s3_bucket_regional_domain_name
    origin_id   = var.aws_s3_bucket_name

    # origin_path = var.origin_path

    s3_origin_config {
      origin_access_identity = var.aws_cloudfront_origin_access_identity_id
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.cloudfront_description
  default_root_object = var.default_root_object
   
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.aws_s3_bucket_name

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