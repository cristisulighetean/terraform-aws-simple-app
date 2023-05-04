variable "aws_region" {
  default = "eu-north-1"
  description = "The AWS region where resources will be created"
}

variable "s3_bucket_name" {
  default = "devops-web-app-data-demo"
  description = "The name of the S3 bucket used for storing Terraform state files"
}

variable "dynamodb_table_name" {
  default = "terraform-state-locking"
  description = "The name of the DynamoDB table used for state file locking"
}