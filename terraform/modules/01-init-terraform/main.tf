locals { 
  bucket_name = "terraform-poc-bucket-${random_string.random.result}"

}

resource "random_string" "random" {
  length           = 8
  special          = false
  lower            = true
  upper            = false
}

resource "aws_s3_bucket" "state_bucket" {
  bucket = local.bucket_name

  tags = {
    Name        = local.bucket_name
    Terraform   = "True"
  }
}

resource "aws_s3_bucket_acl" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.state_bucket.id
  
  versioning_configuration {
    status = "Enabled"
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
 }
  
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-poc-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
