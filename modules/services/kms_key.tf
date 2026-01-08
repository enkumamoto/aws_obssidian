resource "aws_kms_key" "athena_kms_key" {
  deletion_window_in_days = 7
  description             = "Athena KMS Key"
}

resource "aws_kms_key" "elasticache_key" {
  description             = "KMS key for ElastiCache encryption"
  deletion_window_in_days = 30
  tags                    = merge(local.tags, { Name = "sqs_key_${var.environment}" })
}

