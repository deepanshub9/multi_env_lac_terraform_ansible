resource "aws_dynamodb_table" "my_table" {
  name           = "${var.env}-dp-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "UserID"

  attribute {
    name = "UserID"
    type = "S"
  }

  tags = {
    Name        = "${var.env}-dp-table"
    Environment = var.env
  }
  
}