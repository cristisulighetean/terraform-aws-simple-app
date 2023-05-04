# General Variables
variable "app_name" {
  description = "Name of the web application"
  type        = string
  default     = "web-app"
}

variable "environment_name" {
  description = "Deployment environment (dev/staging/production)"
  type        = string
  default     = "dev"
}


# EC2 Variables
variable "ami" {
  description = "Amazon machine image to use for ec2 instance"
  type        = string
  default     = "ami-02c68996dd3d909c1" # Amazon Linux 2023 AMI // eu-north-1
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t3.small"
}


# S3 Variables
variable "bucket_prefix" {
  description = "Prefix of s3 bucket for app data"
  type        = string
}


# Route 53 Variables
variable "create_dns_zone" {
  description = "If true, create new route53 zone, if false read existing route53 zone"
  type        = bool
  default     = false
}

variable "domain" {
  description = "Domain for website"
  type        = string
}


# RDS Variables
variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_user" {
  description = "Username for database"
  type        = string
}

variable "db_pass" {
  description = "Password for database"
  type        = string
  sensitive   = true
}

variable "db_instance_type" {
  description = "Instance type for database"
  type        = string
  default     = "db.t3.small"
}