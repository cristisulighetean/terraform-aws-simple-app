# Configure the Terraform backend for remote state storage
terraform {
  required_version = ">= 1.0"

  backend "s3" {
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS provider with the specified region
provider "aws" {
  region = var.region
}

# Instantiate the web app module for the first web app
module "web_app_1" {
  source = "./web-app-module"

  # Input Variables
  bucket_prefix    = var.web_app_config.bucket_prefix
  domain           = var.web_app_config.domain
  app_name         = "web-app-1"
  environment_name = "production"
  instance_type    = "t3.small"
  create_dns_zone  = true
  db_name          = var.db_credentials.name
  db_user          = var.db_credentials.user
  db_pass          = var.db_credentials.password
}

# Uncomment the following lines to create another instance of the web app
# module "web_app_2" {
#   source = "./web-app-module"

#   # Input Variables
#   bucket_prefix    = "web-app-2-data"
#   domain           = "happybee2.tech"
#   app_name         = "web-app-2"
#   environment_name = "production"
#   instance_type    = "t2.small"
#   create_dns_zone  = true
#   db_name          = "webapp2db"
#   db_user          = "bar"
#   db_pass          = var.db_pass_2
# }
