resource "aws_s3_bucket" "static_hosting" {
  bucket = "gf-cloudresume-chal-hosting"
  tags = {
    Name = "gf-cloudresume-chal-hosting"
  }

}

resource "aws_s3_bucket_public_access_block" "static_hosting" {
  bucket                  = aws_s3_bucket.static_hosting.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "static_hosting" {
  bucket = aws_s3_bucket.static_hosting.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

}

resource "aws_s3_bucket_versioning" "static_hosting" {
  bucket = aws_s3_bucket.static_hosting.bucket
  versioning_configuration {
    status = "Suspended"
  }
}

resource "aws_s3_bucket_website_configuration" "static_hosting" {
  bucket = aws_s3_bucket.static_hosting.id
  index_document {
    suffix = "index.html"
  }
}
