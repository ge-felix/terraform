data "aws_iam_policy_document" "dynamodb_policy" {
  statement {
    actions   = ["dynamodb:PutItem", "dynamodb:DescribeTable", "dynamodb:Scan"]
    resources = [aws_dynamodb_table.browser_time_table.arn]
  }
}

data "aws_iam_policy_document" "lambda_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "LambdaRole"

  assume_role_policy = data.aws_iam_policy_document.lambda_role_policy.json
}

resource "aws_iam_policy" "dynamodb_policy" {
  name        = "DynamoDBPolicy"
  description = "Policy to access DynamoDB table"

  policy = data.aws_iam_policy_document.dynamodb_policy.json
}

resource "aws_iam_policy_attachment" "dynamodb_attachment" {
  name       = "DynamoDBAttachment"
  policy_arn = aws_iam_policy.dynamodb_policy.arn
  roles      = [aws_iam_role.lambda_role.name]
}