resource "aws_cloudfront_origin_access_control" "site_access" {
  name                              = "site_access"
  description                       = "Site Access Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.static_hosting.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.site_access.id
    origin_id                = aws_s3_bucket.static_hosting.id
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.static_hosting.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "https-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = {
    description = "Static site cloudfront distribution."
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}