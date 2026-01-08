output "sqs_component_surveillance_raw_arn" {
  value       = aws_sqs_queue.sqs_component_surveillance_raw.arn
  description = "ARN of the SQS queue: obsidian-component-surveillance-raw"
}

output "sqs_data_collection_frequency_raw_arn" {
  value       = aws_sqs_queue.sqs_data_collection_frequency_raw.arn
  description = "ARN of the SQS queue: obsidian-data-collection-frequency-raw"
}

output "sqs_data_quality_raw_arn" {
  value       = aws_sqs_queue.sqs_data_quality_raw.arn
  description = "ARN of the SQS queue: obsidian-data-quality-raw"
}

output "sqs_data_workflow_raw_arn" {
  value       = aws_sqs_queue.sqs_data_workflow_raw.arn
  description = "ARN of the SQS queue: obsidian-data-workflow-raw"
}

output "sqs_monitor_trigger_arn" {
  value       = aws_sqs_queue.sqs_monitor_trigger.arn
  description = "ARN of the SQS queue: obsidian-monitor-trigger"
}

output "sqs_monitor_trigger_error_arn" {
  value       = aws_sqs_queue.sqs-monitor-trigger_error.arn
  description = "ARN of the SQS queue: obsidian-monitor-trigger_error"
}

output "sqs_tag_config_consistency_raw_arn" {
  value       = aws_sqs_queue.sqs_tag_config_consistency_raw.arn
  description = "ARN of the SQS queue: obsidian-tag-config-consistency-raw"
}

output "sqs_tag_state_raw_arn" {
  value       = aws_sqs_queue.sqs_tag_state_raw.arn
  description = "ARN of the SQS queue: obsidian-tag-state-raw"
}

output "sqs_dataextractor_add_pipoint_arn" {
  value       = aws_sqs_queue.sqs_dataextractor_add_pipoint.arn
  description = "ARN of the SQS queue: dataextractor-add-pipoint"
}

output "sqs_dataextractor_duplicated_pipoint_arn" {
  value       = aws_sqs_queue.sqs_dataextractor-duplicated-pipoint.arn
  description = "ARN of the SQS queue: dataextractor-duplicated-pipoint"
}

output "sqs_dataextractor_duplicated_pipoint_group_arn" {
  value       = aws_sqs_queue.sqs_dataextractor_duplicated_pipoint_group.arn
  description = "ARN of the SQS queue: dataextractor-duplicated-pipoint-group"
}

output "sqs_dataextractor_general_data_arn" {
  value       = aws_sqs_queue.sqs_dataextractor_general_data.arn
  description = "ARN of the SQS queue: dataextractor-general-data"
}

output "sqs_dataextractor_remove_pipoint_arn" {
  value       = aws_sqs_queue.sqs_dataextractor_remove_pipoint.arn
  description = "ARN of the SQS queue: dataextractor-remove-pipoint"
}

output "sqs_dataextractor_template_consistency_report_arn" {
  value       = aws_sqs_queue.sqs_dataextractor-template-consitency-report.arn
  description = "ARN of the SQS queue: dataextractor-template-consitency-report"
}

output "sqs_dataextractor_update_pipoint_arn" {
  value       = aws_sqs_queue.sqs_dataextractor_update_pipoint.arn
  description = "ARN of the SQS queue: dataextractor-update-pipoint"
}

output "sqs_monitor_job_arn" {
  value       = aws_sqs_queue.sqs_monitor_job.arn
  description = "ARN of the SQS queue: monitor-job"
}

output "sqs_dataworkflow_job_arn" {
  value       = aws_sqs_queue.sqs_dataworkflow-job.arn
  description = "ARN of the SQS queue: dataworkflow-job"
}

output "sqs_monitor_job_error_arn" {
  value       = aws_sqs_queue.sqs_monitor-job_error.arn
  description = "ARN of the SQS queue: monitor-job_error"
}
