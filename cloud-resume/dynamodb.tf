resource "aws_dynamodb_table" "browser_time_table" {
  name           = "BrowserTimeTable"
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2

  hash_key  = "BrowserInfo"
  range_key = "TimeAccessed"

  attribute {
    name = "BrowserInfo"
    type = "S"
  }

  attribute {
    name = "TimeAccessed"
    type = "S"
  }
}
