variable "region" {
  type = string
}

variable "environment" {
  type = string
  validation {
    condition     = var.environment == "production" || var.environment == "staging" || var.environment == "sandbox"
    error_message = "Environment must be either production, staging, or sandbox"
  }
}

variable "tags_to_append" {
  type    = map(string)
  default = {}
}

variable "initial_db_name" {
  type = string
}

variable "master_username" {
  type = string
}

variable "master_password" {
  type = string
}

variable "aws_profile" {
  type = string
}

variable "location" {
  type = string
}

variable "account_id" {
  type = string
}

variable "account_cross_id" {
  type = string
}
