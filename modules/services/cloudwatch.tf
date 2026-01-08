resource "aws_cloudwatch_log_group" "keycloak_log_group" {
  name              = "/ecs/keycloak"
  retention_in_days = 7 # Define o período de retenção, ajuste conforme necessário
  tags = {
    Name = "obsidian-keycloak-${var.environment}"
  }
}

resource "aws_cloudwatch_log_group" "obsidian_api_log_group" {
  name              = "/ecs/obsidian-api"
  retention_in_days = 7 # Define o período de retenção, ajuste conforme necessário
  tags = {
    Name = "obsidian-api-${var.environment}"
  }
}

resource "aws_cloudwatch_log_group" "obsidian_datapulling_log_group" {
  name              = "/ecs/obsidian-datapolling"
  retention_in_days = 7 # Define o período de retenção, ajuste conforme necessário
  tags = {
    Name = "obsidian-datapulling-${var.environment}"
  }
}

resource "aws_cloudwatch_log_group" "obsidian_monitor_log_group" {
  name              = "/ecs/obsidian-monitor"
  retention_in_days = 7 # Define o período de retenção, ajuste conforme necessário
  tags = {
    Name = "obsidian-monitor_log_group-${var.environment}"
  }
}

resource "aws_cloudwatch_log_group" "obsidian-all-module-outputs" {
  name              = "/aws/kinesisfirehose/obsidian-all-module-outputs"
  retention_in_days = 7 # Define o período de retenção, ajuste conforme necessário
  tags = {
    Name = "obsidian-all-module-outputs-${var.environment}"
  }
}

resource "aws_cloudwatch_log_group" "obsidian-module-outputs" {
  name              = "/aws/kinesisfirehose/obsidian-module-outputs"
  retention_in_days = 7 # Define o período de retenção, ajuste conforme necessário
  tags = {
    Name = "obsidian-module-outputs-${var.environment}"
  }
}

resource "aws_cloudwatch_log_group" "obsidian-raw-tags" {
  name              = "/aws/kinesisfirehose/raw-tags"
  retention_in_days = 7 # Define o período de retenção, ajuste conforme necessário
  tags = {
    Name = "obsidian-raw-tags-${var.environment}"
  }
}
