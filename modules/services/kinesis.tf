resource "aws_kinesis_stream" "obsidian-module-outputs" {
  name             = "obsidian-module-outputs"
  retention_period = 24

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_kinesis_stream" "obsidian-raw-tags" {
  name             = "obsidian-raw-tags"
  retention_period = 24

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }

  tags = {
    Environment = var.environment
  }
}
