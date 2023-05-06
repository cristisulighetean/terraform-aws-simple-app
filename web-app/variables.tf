# General variables
variable "bucket" {
  description = "The name of the S3 bucket used for storing Terraform state files"
  type = string
  default = "devops-web-app-data-demo"
}

variable "key" {
  description = "The name of the S3 key used for storing Terraform state files"
  type = string
}

variable "dynamodb_table" {
  description = "The name of the DynamoDB table used for state file locking"
  type = string
  default = "terraform-state-locking"
}
variable "region" {
  description = "The AWS region where resources will be created"
  type = string
  default = "eu-north-1"
}

# Web application specific variables
variable "web_app_config" {
  description = "Configuration for the web application"
  type = object({
    bucket_prefix = string
    domain        = string
    instance_type = string
    environment   = string
  })
  default = {
    bucket_prefix = "web-app-1-data"
    domain        = "happybee.tech"
    instance_type = "t3.small"
    environment   = "production"
  }
}

variable "db_credentials" {
  description = "Database credentials"
  type = object({
    name          = string
    user          = string
    password      = string
    instance_type = string
  })
  default = {
    name          = "webapp_db"
    user          = "foo"
    password      = "foobarfoo"
    instance_type = "db.t3.small"
  }
  sensitive = true
}