terraform {

  required_version = ">= 0.13.0"

  backend "s3" {
    # Replace this with your bucket name!
    bucket         = var.remote_state_bucket
    key            = "02-network.tfstate"
    region         = "us-east-2"
    # Replace this with your DynamoDB table name!
    dynamodb_table = var.dynamodb_table
    encrypt        = true
  }
}