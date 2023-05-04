# General variables
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
  })
  default = {
    bucket_prefix = "web-app-1-data"
    domain        = "happybee.tech"
  }
}

variable "db_credentials" {
  description = "Database credentials"
  type = object({
    name     = string
    user     = string
    password = string
  })
  sensitive = true
}