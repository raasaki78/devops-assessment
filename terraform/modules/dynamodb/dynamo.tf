resource "aws_dynamodb_table" "assignment_table" {
  name           = var.table_name
  hash_key       = var.primary_key
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = var.primary_key
    type = "S"
  }

  tags = {
    Name = var.table_name
  }
}

