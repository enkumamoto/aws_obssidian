resource "aws_elasticache_serverless_cache" "example" {
  engine             = "valkey"
  name               = "dashboard-cache"
  kms_key_id         = aws_kms_key.elasticache_key.arn
  security_group_ids = [aws_security_group.allow_service_access.id]
  subnet_ids         = var.vpc_config_public_subnet_ids

  tags = merge(local.tags, { Name = "dashboard-cache-${var.environment}" })
}

output "elasticache_endpoint" {
  value = aws_elasticache_serverless_cache.example.endpoint
}

# Output para nome do cache. TESTAR!
# output "elasticache_dashboard_cache_name" {
#   value = aws_elasticache_serverless_cache.example.name
# }
