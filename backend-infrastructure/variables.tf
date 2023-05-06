variable "bucket" {
  description = "The name of the S3 bucket used for storing Terraform state files"
  type = string
  default = "devops-web-app-data-demo"
}

variable "key" {
  description = "The name of the S3 key used for storing Terraform state files"
  type = string
}

variable "region" {
  description = "The AWS region where resources will be created"
  type = string
  default = "eu-north-1"
}

variable "dynamodb_table" {
  description = "The name of the DynamoDB table used for state file locking"
  type = string
  default = "terraform-state-locking"
}