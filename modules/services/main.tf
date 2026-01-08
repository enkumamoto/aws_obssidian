locals {
  tags               = merge(var.tags_to_append, { Environment = var.environment })
  api_domain_name    = "api.${var.environment}"
  api_v2_domain_name = "api-v2.${var.environment}"
}
