variable "region" {
  description = "The AWS region where resources will be created"
  type = string
  default = "eu-north-1"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket used for storing Terraform state files"
  type = string
  default = "devops-web-app-data-demo"
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table used for state file locking"
  type = string
  default = "terraform-state-locking"
}

variable "remote_state_key" {
  description = "The S3 object key for the Terraform remote state file"
  type = string
  default = "demo-project/import-bootstrap/terraform.tfstate"
}