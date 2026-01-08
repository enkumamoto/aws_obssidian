# variable "name" {
#   description = "Name of the DynamoDB table"
#   type        = string
# }

variable "vpc_id" {
  type = string
}

variable "tags_to_append" {
  type    = map(string)
  default = {}
}

variable "environment" {
  type = string
  validation {
    condition     = var.environment == "production" || var.environment == "staging" || var.environment == "sandbox"
    error_message = "Environment must be either production, staging, or sandbox"
  }
}

variable "region" {
  description = "The region to create the DynamoDB table in"
  type        = string
}

variable "database_route_table_ids" {
  description = "The route table IDs for the database subnets"
  type        = list(string)
  default     = []
}

variable "public_route_table_ids" {
  description = "The route table IDs for the public subnets"
  type        = list(string)
  default     = []
}

variable "intra_route_table_ids" {
  description = "The route table IDs for the private subnets"
  type        = list(string)
  default     = []
}

variable "defaul_security_group_id" {
  type    = list(string)
  default = []
}
