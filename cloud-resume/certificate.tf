resource "aws_acm_certificate" "cloud_resume" {
  domain_name       = "cv.${var.mydomain}"
  validation_method = "DNS"
  provider = aws.us-east-1
}

resource "aws_acm_certificate_validation" "cloud_resume" {
    depends_on = [
    aws_route53_record.cloud_resume
  ]
  certificate_arn         = aws_acm_certificate.cloud_resume.arn
  validation_record_fqdns = [for record in aws_route53_record.cloud_resume : record.fqdn]
  provider = aws.us-east-1
}
