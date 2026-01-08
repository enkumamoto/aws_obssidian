resource "aws_sqs_queue" "sqs_component_surveillance_raw" {
  name                       = "obsidian-component-surveillance-raw"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  sqs_managed_sse_enabled = true

  tags = local.tags
}

resource "aws_sqs_queue" "sqs_data_collection_frequency_raw" {
  name                       = "obsidian-data-collection-frequency-raw"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  sqs_managed_sse_enabled = true

  tags = local.tags
}

resource "aws_sqs_queue" "sqs_data_quality_raw" {
  name                       = "obsidian-data-quality-raw"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  sqs_managed_sse_enabled = true

  tags = local.tags
}

resource "aws_sqs_queue" "sqs_data_workflow_raw" {
  name                       = "obsidian-data-workflow-raw"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  sqs_managed_sse_enabled = true

  tags = local.tags
}

resource "aws_sqs_queue" "sqs_monitor_trigger" {
  name                       = "obsidian-monitor-trigger"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  sqs_managed_sse_enabled = true

  tags = local.tags
}

resource "aws_sqs_queue" "sqs-monitor-trigger_error" {
  name                       = "obsidian-monitor-trigger_error"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  sqs_managed_sse_enabled = true

  tags = local.tags
}

resource "aws_sqs_queue" "sqs_tag_config_consistency_raw" {
  name                       = "obsidian-tag-config-consistency-raw"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  sqs_managed_sse_enabled = true

  tags = local.tags
}

resource "aws_sqs_queue" "sqs_tag_state_raw" {
  name                       = "obsidian-tag-state-raw"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  sqs_managed_sse_enabled = true

  tags = local.tags
}

resource "aws_sqs_queue" "sqs_dataextractor_add_pipoint" {
  name                       = "dataextractor-add-pipoint"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  sqs_managed_sse_enabled = true

  tags = local.tags
}

resource "aws_sqs_queue" "sqs_dataextractor-duplicated-pipoint" {
  name                       = "dataextractor-duplicated-pipoint"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  sqs_managed_sse_enabled = true

  tags = local.tags
}

resource "aws_sqs_queue" "sqs_dataextractor_duplicated_pipoint_group" {
  name                       = "dataextractor-duplicated-pipoint-group"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  sqs_managed_sse_enabled = true

  tags = local.tags
}

resource "aws_sqs_queue" "sqs_dataextractor_general_data" {
  name                       = "dataextractor-general-data"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  sqs_managed_sse_enabled    = true

  tags = local.tags
}

resource "aws_sqs_queue" "sqs_dataextractor_remove_pipoint" {
  name                       = "dataextractor-remove-pipoint"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  sqs_managed_sse_enabled = true

  tags = local.tags
}

resource "aws_sqs_queue" "sqs_dataextractor-template-consitency-report" {
  name                       = "dataextractor-template-consitency-report"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  sqs_managed_sse_enabled = true

  tags = local.tags
}

resource "aws_sqs_queue" "sqs_dataextractor_update_pipoint" {
  name                       = "dataextractor-update-pipoint"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  sqs_managed_sse_enabled = true

  tags = local.tags
}

resource "aws_sqs_queue" "sqs_monitor_job" {
  name                       = "monitor-job"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  sqs_managed_sse_enabled = true

  tags = local.tags
}

resource "aws_sqs_queue" "sqs_dataworkflow-job" {
  name                       = "dataworkflow-job"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  sqs_managed_sse_enabled = true

  tags = local.tags
}

resource "aws_sqs_queue" "sqs_monitor-job_error" {
  name                       = "monitor-job_error"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  sqs_managed_sse_enabled = true

  tags = local.tags
}
