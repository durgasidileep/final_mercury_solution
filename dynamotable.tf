resource "aws_dynamodb_table" "mercury_statelock" {
  name           = "mercury-lock-state"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}





