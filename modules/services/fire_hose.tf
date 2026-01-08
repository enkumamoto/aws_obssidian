resource "aws_kinesis_firehose_delivery_stream" "obsidian-all-module-outputs" {
  name        = "obsidian-all-module-outputs"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn           = aws_iam_role.obsidian-firehose-role.arn
    bucket_arn         = aws_s3_bucket.obsidian-all-module-outputs.arn
    buffering_size     = 128
    buffering_interval = 300
    compression_format = "GZIP"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.obsidian-all-module-outputs.name
      log_stream_name = "DestinationDelivery"
    }

    dynamic_partitioning_configuration {
      enabled        = true
      retry_duration = 300
    }

    prefix              = "date=!{partitionKeyFromQuery:date}/"
    error_output_prefix = "error/"

    processing_configuration {
      enabled = "true"

      processors {
        type = "RecordDeAggregation"
        parameters {
          parameter_name  = "SubRecordType"
          parameter_value = "JSON"
        }
      }

      processors {
        type = "AppendDelimiterToRecord"
      }

      processors {
        type = "MetadataExtraction"

        parameters {
          parameter_name  = "JsonParsingEngine"
          parameter_value = "JQ-1.6"
        }

        parameters {
          parameter_name  = "MetadataExtractionQuery"
          parameter_value = "{date:now | strftime(\"%Y-%m-%d\")}"
        }

      }
    }
  }

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.obsidian-module-outputs.arn
    role_arn           = aws_iam_role.obsidian-firehose-role.arn
  }

  depends_on = [aws_s3_bucket.obsidian-all-module-outputs]

  tags = local.tags
}

resource "aws_kinesis_firehose_delivery_stream" "obsidian-module-outputs" {
  name        = "obsidian-module-outputs"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn           = aws_iam_role.obsidian-firehose-role.arn
    bucket_arn         = aws_s3_bucket.obsidian-module-outputs.arn
    buffering_size     = 128
    buffering_interval = 120
    compression_format = "GZIP"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.obsidian-module-outputs.name
      log_stream_name = "DestinationDelivery"
    }

    dynamic_partitioning_configuration {
      enabled        = true
      retry_duration = 300
    }

    prefix              = "module=!{partitionKeyFromQuery:module}/group_id=!{partitionKeyFromQuery:group_id}/subgroup_id=!{partitionKeyFromQuery:subgroup_id}/date=!{partitionKeyFromQuery:date}/"
    error_output_prefix = "error/"

    processing_configuration {
      enabled = "true"

      processors {
        type = "RecordDeAggregation"
        parameters {
          parameter_name  = "SubRecordType"
          parameter_value = "JSON"
        }
      }

      processors {
        type = "AppendDelimiterToRecord"
      }

      processors {
        type = "MetadataExtraction"

        parameters {
          parameter_name  = "JsonParsingEngine"
          parameter_value = "JQ-1.6"
        }

        parameters {
          parameter_name  = "MetadataExtractionQuery"
          parameter_value = "{module:.module,group_id:.groupId,subgroup_id:.subgroupId,date:now | strftime(\"%Y-%m-%d\")}"
        }
      }
    }
  }

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.obsidian-module-outputs.arn
    role_arn           = aws_iam_role.obsidian-firehose-role.arn
  }

  depends_on = [aws_s3_bucket.obsidian-module-outputs]

  tags = local.tags
}

resource "aws_kinesis_firehose_delivery_stream" "obsidian-raw-tags" {
  name        = "raw-tags"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn           = aws_iam_role.obsidian-firehose-role.arn
    bucket_arn         = aws_s3_bucket.obsidian-raw-tags.arn
    buffering_size     = 128
    buffering_interval = 120
    compression_format = "GZIP"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.obsidian-raw-tags.name
      log_stream_name = "DestinationDelivery"
    }

    dynamic_partitioning_configuration {
      enabled        = true
      retry_duration = 300
    }

    prefix              = "data_archive_server=!{partitionKeyFromQuery:dataArchiveServer}/date=!{partitionKeyFromQuery:date}/"
    error_output_prefix = "error/"

    processing_configuration {
      enabled = "true"


      processors {
        type = "RecordDeAggregation"
        parameters {
          parameter_name  = "SubRecordType"
          parameter_value = "JSON"
        }
      }

      processors {
        type = "AppendDelimiterToRecord"
      }

      processors {
        type = "MetadataExtraction"

        parameters {
          parameter_name  = "MetadataExtractionQuery"
          parameter_value = "{dataArchiveServer:.dataArchiveServer,date:now | strftime(\"%Y-%m-%d\")}" # Extrai a chave 'date' da mensagem JSON.
        }

        parameters {
          parameter_name  = "JsonParsingEngine"
          parameter_value = "JQ-1.6" # Usa a engine JQ para parsing do JSON.
        }
      }
    }
  }

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.obsidian-raw-tags.arn
    role_arn           = aws_iam_role.obsidian-firehose-role.arn
  }

  depends_on = [aws_s3_bucket.obsidian-all-module-outputs]

  tags = local.tags
}

resource "aws_iam_role" "obsidian-firehose-role" {
  name               = "obsidian_firehose_role"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json
}

resource "aws_iam_policy" "obsidian_firehose_policy" {
  name   = "obsidian_firehose_policy"
  policy = data.aws_iam_policy_document.firehose_policy.json
}

resource "aws_iam_role_policy_attachment" "obsidian_firehose_policy_attachment" {
  role       = aws_iam_role.obsidian-firehose-role.name
  policy_arn = aws_iam_policy.obsidian_firehose_policy.arn
}

data "aws_iam_policy_document" "firehose_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "firehose_policy" {
  statement {
    effect = "Allow"
    actions = [
      "kinesis:GetRecords",
      "kinesis:GetShardIterator",
      "kinesis:DescribeStream",
      "kinesis:DescribeStreamSummary",
      "kinesis:ListShards",
      "kinesis:ListStreams",
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "logs:CreateLogGroup"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
