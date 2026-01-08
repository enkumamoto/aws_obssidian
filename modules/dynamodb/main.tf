locals {
  tags = merge(var.tags_to_append, { Environment = var.environment })
}

module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id             = var.vpc_id
  security_group_ids = var.defaul_security_group_id

  endpoints = {
    s3 = {
      service = "s3"
      tags    = local.tags
    },
    dynamodb = {
      service         = "dynamodb"
      service_type    = "Gateway"
      route_table_ids = flatten([var.intra_route_table_ids, var.public_route_table_ids])
      tags            = local.tags
    },
  }
  tags = local.tags
}

resource "aws_dynamodb_table" "raw_tags_table" {
  name             = "obsidian-raw-tags"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = false
  stream_view_type = "NEW_IMAGE"
  hash_key         = "pk"
  range_key        = "sk"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  attribute {
    name = "gsiPk1"
    type = "S"
  }

  attribute {
    name = "gsiSk1"
    type = "S"
  }

  global_secondary_index {
    name            = "gsiPk1-gsiSk1-index"
    hash_key        = "gsiPk1"
    range_key       = "gsiSk1"
    projection_type = "ALL"
  }

  tags = {
    Environment = var.environment
    Name        = "Raw Tags Table"
  }
}

resource "aws_dynamodb_table" "module_outputs_table" {
  name             = "obsidian-module-outputs"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"
  hash_key         = "pk"
  range_key        = "sk"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  tags = {
    Environment = var.environment
    Name        = "Module Outputs Table"
  }
}

# criar output para obsidian-module-outputs
output "module_outputs_table" {
  value = aws_dynamodb_table.module_outputs_table.stream_arn
}

resource "aws_dynamodb_table" "module_config_table" {
  name             = "obsidian-module-configs"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = false
  stream_view_type = "NEW_IMAGE"
  hash_key         = "pk"
  range_key        = "sk"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  attribute {
    name = "gsiSk1"
    type = "S"
  }

  global_secondary_index {
    name            = "pk-gsiSk1-index"
    hash_key        = "pk"
    range_key       = "gsiSk1"
    projection_type = "ALL"
  }

  tags = {
    Environment = var.environment
    Name        = "Module Outputs Table"
  }
}

resource "aws_dynamodb_table" "monitor_outputs_metadata_table" {
  name             = "obsidian-monitor-metadata"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"
  hash_key         = "pk"
  range_key        = "sk"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  tags = {
    Environment = var.environment
    Name        = "Monitor Outputs Metadata Table"
  }
}

output "monitor_outputs_metadata_table" {
  value = aws_dynamodb_table.monitor_outputs_metadata_table.stream_arn
}

resource "aws_dynamodb_table" "monitor_warning_outputs_table" {
  name             = "obsidian-monitor-warnings"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = false
  stream_view_type = "NEW_IMAGE"
  hash_key         = "pk"
  range_key        = "sk"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  attribute {
    name = "gsiSk1"
    type = "S"
  }

  attribute {
    name = "gsiSk2"
    type = "S"
  }

  global_secondary_index {
    name            = "pk-gsiSk1-index"
    hash_key        = "pk"
    range_key       = "gsiSk1"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "pk-gsiSk2-index"
    hash_key        = "pk"
    range_key       = "gsiSk2"
    projection_type = "ALL"
  }

  tags = {
    Environment = var.environment
    Name        = "Monitor Warning Outputs Table"
  }
}

resource "aws_dynamodb_table" "group_config_table" {
  name             = "obsidian-group-configs"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = false
  stream_view_type = "NEW_IMAGE"
  hash_key         = "pk"
  range_key        = "sk"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  tags = {
    Environment = var.environment
    Name        = "Group Config Table"
  }
}
