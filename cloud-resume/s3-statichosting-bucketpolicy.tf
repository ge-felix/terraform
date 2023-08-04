data "aws_iam_policy_document" "cf_origin" {
    depends_on = [ 
        aws_cloudfront_distribution.s3_distribution,
        aws_s3_bucket.static_hosting 
        ]

    statement{
        sid = "s3_cloudfront _static_website"
        effect = "Allow"
        actions = [
            "s3:GetObject"
        ]
        principals {
            identifiers = ["cloudfront.amazonaws.com"]
            type = "Service"
        }
        resources = [
            "arn:aws:s3:::${aws_s3_bucket.static_hosting.bucket}/*"
        ]
        condition {
            test = "StringEquals"
            variable = "AWS:SourceArn"
            values = [ aws_cloudfront_distribution.s3_distribution.arn]
        }
    }
}

resource "aws_s3_bucket_policy" "static_hosting" {
    bucket = aws_s3_bucket.static_hosting.id
    policy = data.aws_iam_policy_document.cf_origin.json
    depends_on = [
        data.aws_iam_policy_document.cf_origin
     ]
}