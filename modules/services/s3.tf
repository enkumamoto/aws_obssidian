resource "aws_s3_bucket" "log-bucket" {
  bucket = "obsidian-lb-logs-${var.environment}"

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "athena_bucket" {
  bucket = "obsidian-query-outputs-${var.environment}"

  force_destroy = true

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "obsidian-monitor-metadata" {
  bucket = "obsidian-monitor-metadata-${var.environment}"

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "obsidian-dataworkflow" {
  bucket = "obsidian-dataworkflow-${var.environment}"

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "obsidian-monitor-warnings" {
  bucket = "obsidian-monitor-warnings-${var.environment}"

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "obsidian-raw-tags" {
  bucket = "obsidian-raw-tags-${var.environment}"

  tags = {
    Environment = var.environment
  }
}


resource "aws_s3_bucket" "obsidian-all-module-outputs" {
  bucket = "obsidian-all-module-outputs-${var.environment}"

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "obsidian-module-outputs" {
  bucket = "obsidian-module-outputs-${var.environment}"

  tags = {
    Environment = var.environment
  }
}
