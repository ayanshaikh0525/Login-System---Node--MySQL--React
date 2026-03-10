variable "aws_region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "login-app"
}

variable "db_username" {}
variable "db_password" {}

variable "db_name" {
    type = string
}

variable "JWT_SECRET" {
  type = string
}

variable "db_tablename" {
  type = string
}