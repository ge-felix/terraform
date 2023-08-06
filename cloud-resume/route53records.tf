data "aws_route53_zone" "main" {
  name = "${var.mydomain}"
}

resource "aws_route53_record" "cloud_resume" {
  for_each = {
    for dvo in aws_acm_certificate.cloud_resume.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main.zone_id
}

resource "aws_route53_record" "cloudfront_cname" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "cv"  # Subdomain name, e.g., cdn.yourdomain.com
  type    = "CNAME"
  ttl     = "300"
  records = [aws_cloudfront_distribution.s3_distribution.domain_name]
}