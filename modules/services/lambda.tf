# Lambda loader function
resource "aws_lambda_function" "lambda_loader" {
  function_name = "obsidianLoader"
  role          = aws_iam_role.iam_lambda.arn
  description   = "obsidian Loader Function"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  environment {
    variables = {
      AWS__Region = var.region 
    }
  }

  image_uri    = "${var.account_cross_id}.dkr.ecr.${var.region}.amazonaws.com/obsidian/lambda/loader-function:latest"
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }
  tags = {
    Name        = "obsidianLoader"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

output "lambda_loader_arn" {
  value = aws_lambda_function.lambda_loader.arn
}

resource "aws_lambda_event_source_mapping" "lambda_loader_trigger_1" {
  event_source_arn                   = aws_sqs_queue.sqs_dataextractor_add_pipoint.arn
  function_name                      = aws_lambda_function.lambda_loader.arn
  batch_size                         = 2000
  maximum_batching_window_in_seconds = 1
}

resource "aws_lambda_event_source_mapping" "lambda_loader_trigger_2" {
  event_source_arn                   = aws_sqs_queue.sqs_dataextractor_update_pipoint.arn
  function_name                      = aws_lambda_function.lambda_loader.arn
  batch_size                         = 2000
  maximum_batching_window_in_seconds = 1
}

resource "aws_lambda_event_source_mapping" "lambda_loader_trigger_3" {
  event_source_arn                   = aws_sqs_queue.sqs_dataextractor_remove_pipoint.arn
  function_name                      = aws_lambda_function.lambda_loader.arn
  batch_size                         = 2000
  maximum_batching_window_in_seconds = 1
}

resource "aws_lambda_event_source_mapping" "lambda_loader_trigger_4" {
  event_source_arn                   = aws_sqs_queue.sqs_dataextractor_general_data.arn
  function_name                      = aws_lambda_function.lambda_loader.arn
  batch_size                         = 2000
  maximum_batching_window_in_seconds = 1
}

# Lambda Duplicate Tags function
resource "aws_lambda_function" "lambda_duplicated_tags" {
  function_name = "DuplicatedTags"
  role          = aws_iam_role.iam_lambda.arn
  description   = "Duplicated Tags Function"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${var.account_cross_id}.dkr.ecr.${var.region}.amazonaws.com/obsidian/lambda/duplicatedtags-function:latest"
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  environment {
    variables = {
      AWS__Region = var.region # add esta variável em todas as lambdas
    }
  }

  tags = {
    Name        = "obsidianDuplicatedTags"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

resource "aws_lambda_event_source_mapping" "lambda_duplicated_tags_trigger" {
  event_source_arn = aws_sqs_queue.sqs_dataextractor-duplicated-pipoint.arn
  function_name    = aws_lambda_function.lambda_duplicated_tags.arn
}

output "lambda_duplicated_tags_arn" {
  value = aws_lambda_function.lambda_duplicated_tags.arn
}

# Lambda Data Work Flow function
resource "aws_lambda_function" "lambda_data_work_flow_function" {
  function_name = "DataWorkflow"
  role          = aws_iam_role.iam_lambda.arn
  description   = "Data Work Flow Function"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${var.account_cross_id}.dkr.ecr.${var.region}.amazonaws.com/obsidian/lambda/dataworkflow-function:latest"
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  environment {
    variables = {
      AWS__Region = var.region # add esta variável em todas as lambdas
    }
  }

  tags = {
    Name        = "obsidianDataWorkflow"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

resource "aws_s3_bucket_notification" "obsidian_dataworkflow_notification" {
  bucket = aws_s3_bucket.obsidian-dataworkflow.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_data_work_flow_function.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.obsidian_dataworkflow_permission]
}

resource "aws_lambda_permission" "obsidian_dataworkflow_permission" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_data_work_flow_function.function_name
  principal     = "s3.amazonaws.com"

  source_arn = aws_s3_bucket.obsidian-dataworkflow.arn
}

output "lambda_data_work_flow_function_arn" {
  value = aws_lambda_function.lambda_data_work_flow_function.arn
}

# Lambda obsidianDuplicatedTagsMonitor
resource "aws_lambda_function" "lambda_duplicated_tags_monitor" {
  function_name = "obsidianDuplicatedTagsMonitor"
  role          = aws_iam_role.iam_lambda.arn
  description   = "obsidian Duplicated Tags Monitor Function"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${var.account_cross_id}.dkr.ecr.${var.region}.amazonaws.com/obsidian/lambda/duplicatedtags-monitor-function:latest"
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  environment {
    variables = {
      AWS__Region = var.region # add esta variável em todas as lambdas
    }
  }

  tags = {
    Name        = "obsidianDuplicatedTagsMonitor"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

resource "aws_lambda_event_source_mapping" "lambda_duplicated_tags_monitor_trigger" {
  event_source_arn = aws_sqs_queue.sqs_dataextractor_duplicated_pipoint_group.arn
  function_name    = aws_lambda_function.lambda_duplicated_tags_monitor.arn
}

output "lambda_duplicated_tags_monitor_arn" {
  value = aws_lambda_function.lambda_duplicated_tags_monitor.arn
}

# Função obsidianMetadataMerger
resource "aws_lambda_function" "lambda_metadata_merger_function" {
  function_name = "obsidianMetadataMerger"
  role          = aws_iam_role.iam_lambda.arn
  description   = "obsidian Metadata Merger Function"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${var.account_cross_id}.dkr.ecr.${var.region}.amazonaws.com/obsidian/lambda/metadata-merger-function:latest"
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  environment {
    variables = {
      AWS__Region = var.region # add esta variável em todas as lambdas
    }
  }

  tags = {
    Name        = "obsidianMetadataMerger"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

# Event Source Mapping - Agora usando o ARN do Stream de DynamoDB
resource "aws_lambda_event_source_mapping" "dynamodb_monitor_warning_outputs_trigger" {
  event_source_arn       = var.monitor_outputs_metadata_table
  function_name          = aws_lambda_function.lambda_metadata_merger_function.arn
  enabled                = true
  batch_size             = 100
  parallelization_factor = 1
  filter_criteria {
    filter {
      pattern = jsonencode({
        "dynamodb" : {
          "NewImage" : {
            "pk" : {
              "S" : [
                { "prefix" : "SUBGROUP#" },
                { "prefix" : "GROUP#" }
              ]
            }
          }
        }
        }
      )
    }
  }
  starting_position = "LATEST"
}

output "lambda_metadata_merger_function_arn" {
  value = aws_lambda_function.lambda_metadata_merger_function.arn
}

# Função obsidianTagMonitor
resource "aws_lambda_function" "lambda_tag_monitor_function" {
  function_name = "obsidianTagMonitor"
  role          = aws_iam_role.iam_lambda.arn
  description   = "obsidian Tag Monitor Function"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${var.account_cross_id}.dkr.ecr.${var.region}.amazonaws.com/obsidian/lambda/tagmonitor-function:latest"
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  environment {
    variables = {
      AWS__Region = var.region # add esta variável em todas as lambdas
    }
  }

  tags = {
    Name        = "obsidianTagMonitor"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

resource "aws_s3_bucket_notification" "obsidian-monitor-metadata_notification" {
  bucket = aws_s3_bucket.obsidian-monitor-metadata.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_tag_monitor_function.arn
    events              = ["s3:ObjectCreated:*"]    
  }

  depends_on = [aws_lambda_permission.obsidian-monitor-metadata_permission]
}

resource "aws_lambda_permission" "obsidian-monitor-metadata_permission" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_tag_monitor_function.function_name
  principal     = "s3.amazonaws.com"

  source_arn = aws_s3_bucket.obsidian-monitor-metadata.arn
}

output "lambda_tag_monitor_function_arn" {
  value = aws_lambda_function.lambda_tag_monitor_function.arn
}

# Função obsidianTagMonitorWarnings
resource "aws_lambda_function" "lambda_tag_monitor_warnings_function" {
  function_name = "obsidianTagMonitorWarnings"
  role          = aws_iam_role.iam_lambda.arn
  description   = "obsidian Tag Monitor Warnings Function"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${var.account_cross_id}.dkr.ecr.${var.region}.amazonaws.com/obsidian/lambda/tagmonitorwarnings-function:latest"
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  environment {
    variables = {
      AWS__Region = var.region # add esta variável em todas as lambdas
    }
  }

  tags = {
    Name        = "obsidianTagMonitor"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

# Event Source Mapping - Agora usando o ARN do Stream de DynamoDB
resource "aws_lambda_event_source_mapping" "kinesis_monitor_warning_outputs_trigger" {
  event_source_arn  = aws_kinesis_stream.obsidian-module-outputs.arn
  function_name     = aws_lambda_function.lambda_tag_monitor_warnings_function.arn
  starting_position = "LATEST"

  depends_on = [aws_kinesis_stream.obsidian-module-outputs]
}

output "lambda_tag_monitor_warnings_function_arn" {
  value = aws_lambda_function.lambda_tag_monitor_warnings_function.arn
}

# Função obsidianTagProcessor
resource "aws_lambda_function" "lambda_tag_processor_function" {
  function_name = "obsidianTagProcessor"
  role          = aws_iam_role.iam_lambda.arn
  description   = "obsidian Tag Processor Function"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${var.account_cross_id}.dkr.ecr.${var.region}.amazonaws.com/obsidian/lambda/tagprocessor-function:latest"
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  environment {
    variables = {
      AWS__Region = var.region # add esta variável em todas as lambdas
    }
  }

  tags = {
    Name        = "obsidianTagProcessor"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

# Event Source Mapping - Agora usando o ARN do Stream de DynamoDB
resource "aws_lambda_event_source_mapping" "kinesis_raw_tags_trigger" {
  event_source_arn  = aws_kinesis_stream.obsidian-raw-tags.arn
  function_name     = aws_lambda_function.lambda_tag_processor_function.arn
  starting_position = "LATEST"
}

output "lambda_tag_processor_function_arn" {
  value = aws_lambda_function.lambda_tag_processor_function.arn
}

resource "aws_lambda_function" "lambda_template_consistency" {
  function_name = "TemplateConsistency"
  role          = aws_iam_role.iam_lambda.arn
  description   = "obsidian Template consistency Function"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${var.account_cross_id}.dkr.ecr.${var.region}.amazonaws.com/obsidian/lambda/templateconsistency-function:latest"
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  environment {
    variables = {
      AWS__Region = var.region # add esta variável em todas as lambdas
    }
  }

  tags = {
    Name        = "obsidianDuplicatedTagsMonitor"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

resource "aws_lambda_event_source_mapping" "lambda_template_consistencyr_trigger" {
  event_source_arn = aws_sqs_queue.sqs_dataextractor-template-consitency-report.arn
  function_name    = aws_lambda_function.lambda_template_consistency.arn
}

output "lambda_template_consistency_arn" {
  value = aws_lambda_function.lambda_template_consistency.arn
}
