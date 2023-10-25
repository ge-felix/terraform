data "archive_file" "lambda" {
  type        = "zip"
  source_file = "dbquery.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "lambda_dbquery" {
  function_name = "DynamoDBQueryLambdaFunction"
  role          = aws_iam_role.lambda_role.arn
  handler       = "dbquery.lambda_handler"
  runtime       = "python3.8"

  filename = "lambda_function_payload.zip"

  source_code_hash = data.archive_file.lambda.output_base64sha256
}
