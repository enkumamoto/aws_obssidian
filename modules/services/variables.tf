variable "region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "sandbox"
  validation {
    condition     = var.environment == "production" || var.environment == "staging" || var.environment == "sandbox"
    error_message = "Environment must be either production, staging, or sandbox"
  }
}

variable "tags_to_append" {
  type    = map(string)
  default = {}
}

##########SQS Queue Variables#############
variable "sqs_delayseconds" {
  type    = number
  default = 0
}
variable "max_message_size" {
  type    = number
  default = 262144
}
variable "message_retention_seconds" {
  type    = number
  default = 345600
}
variable "visibility_timeout_seconds" {
  type    = number
  default = 600
}
variable "receive_wait_time_seconds" {
  type    = number
  default = 10
}

######Lambda Variables###########
variable "lambda_vpc_config_subnet_ids" {
  type    = list(string)
  default = []
}

variable "lambda_vpc_config_security_group_ids" {
  type    = list(string)
  default = []
}

variable "lambda_description" {
  type    = string
  default = "Lambda function which calls code from S3 and invokes when S3 queue recieves a message"
}

variable "lambda_memory_size" {
  type    = number
  default = 256
}

variable "lambda_timeout" {
  type    = number
  default = 180
}

variable "lambda_monitor_timeout" {
  type    = number
  default = 600
}

variable "monitor_outputs_metadata_table" {
  type = string
}

variable "module_outputs_table" {
  type = string
}

##########ECS Cluster Variables#############
variable "ecs_cluster_id" {
  type        = string
  description = "The ID of the ECS cluster"
}

variable "vpc_config_private_app_subnet_ids" {
  type        = list(string)
  description = "The list of private app subnet ids"
}

variable "vpc_config_public_subnet_ids" {
  type    = list(string)
  default = []
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

variable "service_environment" {
  type    = map(string)
  default = {}
}

variable "service_secrets" {
  type    = map(string)
  default = {}
}

variable "service_cpu_unit" {
  type        = number
  description = "CPU unit of service (256, 512, 1024 ...)"
  default     = 256
}

variable "service_memory_mb" {
  type        = number
  description = "Memory mb of service (1024, 2048, 4096 ...)"
  default     = 2048
}

## Others
variable "location" {
  type = string
}

variable "account_id" {
  type = string
}

variable "account_cross_id" {
  type = string
}

variable "master_username" {
  type = string
}

variable "master_password" {
  type = string
}

variable "db_host" {
  type = string
}

# variable "db_keycloak_host" {
#   type = string
# }

variable "db_name" {
  type = string
}
