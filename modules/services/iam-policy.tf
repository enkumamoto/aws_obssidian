resource "aws_iam_policy" "api" {
  name = "obsidian_apigateway_sqs_policy_${var.environment}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "sqs:GetQueueUrl",
          "sqs:ChangeMessageVisibility",
          "sqs:ListDeadLetterSourceQueues",
          "sqs:SendMessageBatch",
          "sqs:PurgeQueue",
          "sqs:ReceiveMessage",
          "sqs:SendMessage",
          "sqs:GetQueueAttributes",
          "sqs:CreateQueue",
          "sqs:ListQueueTags",
          "sqs:ChangeMessageVisibilityBatch",
          "sqs:SetQueueAttributes"
        ],
        "Resource": [
          "${aws_sqs_queue.sqs_component_surveillance_raw.arn}",
          "${aws_sqs_queue.sqs_data_collection_frequency_raw.arn}",
          "${aws_sqs_queue.sqs_data_quality_raw.arn}",
          "${aws_sqs_queue.sqs_data_workflow_raw.arn}",
          "${aws_sqs_queue.sqs_monitor_trigger.arn}",
          "${aws_sqs_queue.sqs-monitor-trigger_error.arn}",
          "${aws_sqs_queue.sqs_tag_config_consistency_raw.arn}",
          "${aws_sqs_queue.sqs_tag_state_raw.arn}",
          "${aws_sqs_queue.sqs_dataextractor_add_pipoint.arn}",
          "${aws_sqs_queue.sqs_dataextractor-duplicated-pipoint.arn}",
          "${aws_sqs_queue.sqs_dataextractor_duplicated_pipoint_group.arn}",
          "${aws_sqs_queue.sqs_dataextractor_general_data.arn}",
          "${aws_sqs_queue.sqs_dataextractor_remove_pipoint.arn}",
          "${aws_sqs_queue.sqs_dataextractor-template-consitency-report.arn}",
          "${aws_sqs_queue.sqs_dataextractor_update_pipoint.arn}",
          "${aws_sqs_queue.sqs_monitor_job.arn}",
          "${aws_sqs_queue.sqs_monitor-job_error.arn}",
          "${aws_sqs_queue.sqs_dataworkflow-job.arn}"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "kms:GenerateDataKey",
          "kms:Decrypt"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": "sqs:ListQueues",
        "Resource": "*"
      }
    ]
}
EOF
  tags   = local.tags
}

resource "aws_iam_policy" "rds_policy" {
  name   = "obsidian_rds_policy_${var.environment}"
  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action":[
            "rds:CreateDBInstance",
            "rds:ModifyDBInstance",
            "rds:CreateDBSnapshot"
         ],
         "Resource":"*",
         "Condition": {
            "StringLike": {
                "iam:AWSServiceName": [
                    "rds.amazonaws.com"
                ]
            }
        }
      }
   ]
}
EOF
  tags   = local.tags
}

resource "aws_s3_bucket_policy" "lb_logs_policy" {
  bucket = aws_s3_bucket.log-bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowLBLogging",
        Effect = "Allow",
        Principal = {
          Service = "logs.${var.region}.amazonaws.com"
        },
        Action = [
          "s3:PutObject"
        ],
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.log-bucket.bucket}/*"
        ]
      }
    ]
  })

  depends_on = [aws_s3_bucket.log-bucket]
}
