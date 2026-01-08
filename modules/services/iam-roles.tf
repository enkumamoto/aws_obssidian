#IAM Resource block for Lambda IAM role.
resource "aws_iam_role" "iam_lambda" {
  name = "obsidian_lambda_iam_role_${var.environment}"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  tags = local.tags
}

resource "aws_iam_policy" "lambda_kinesis_policy" {
  name        = "LambdaKinesisPolicy"
  description = "Policy for Lambda to access Kinesis Streams"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kinesis:GetRecords",
          "kinesis:GetShardIterator",
          "kinesis:DescribeStream",
          "kinesis:DescribeStreamSummary",
          "kinesis:ListShards",
          "kinesis:ListStreams"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_attach_kinesis_policy" {
  role       = aws_iam_role.iam_lambda.name
  policy_arn = aws_iam_policy.lambda_kinesis_policy.arn
}

#Attachment of a Managed AWS IAM Policy for Lambda basic execution
resource "aws_iam_role_policy_attachment" "lambda_basic_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.iam_lambda.name
}

#Attachment of a Managed AWS IAM Policy for Lambda basic execution
resource "aws_iam_role_policy_attachment" "lambda_vpc_access_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.iam_lambda.name
}

#Attachment of a Managed AWS IAM Policy for Lambda sqs execution
resource "aws_iam_role_policy_attachment" "lambda_basic_sqs_queue_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
  role       = aws_iam_role.iam_lambda.name
}

resource "aws_iam_role_policy_attachment" "lambda_s3_readonly_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.iam_lambda.name
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_monitor_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  role       = aws_iam_role.iam_lambda.name
}

resource "aws_iam_role_policy_attachment" "lambda_kinesis_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFullAccess"
  role       = aws_iam_role.iam_lambda.name
}

resource "aws_iam_role_policy_attachment" "lambda_sqs_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
  role       = aws_iam_role.iam_lambda.name
}

resource "aws_iam_role_policy_attachment" "lambda_invocation_dynamo_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaInvocation-DynamoDB"
  role       = aws_iam_role.iam_lambda.name
}

#Attachment of a custom IAM policy for API Gateway
resource "aws_iam_role_policy_attachment" "api" {
  role       = aws_iam_role.api.name
  policy_arn = aws_iam_policy.api.arn
}

resource "aws_iam_role" "api" {
  name = "obsidian_api_gateway_role_${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags               = local.tags
}

data "aws_iam_policy_document" "api" {
  statement {
    actions = [
      "sqs:SendMessage",
    ]
    resources = [
      aws_sqs_queue.sqs_component_surveillance_raw.arn,
      aws_sqs_queue.sqs_data_collection_frequency_raw.arn,
      aws_sqs_queue.sqs_data_quality_raw.arn,
      aws_sqs_queue.sqs_data_workflow_raw.arn,
      aws_sqs_queue.sqs_monitor_trigger.arn,
      aws_sqs_queue.sqs-monitor-trigger_error.arn,
      aws_sqs_queue.sqs_tag_config_consistency_raw.arn,
      aws_sqs_queue.sqs_tag_state_raw.arn,
      aws_sqs_queue.sqs_dataextractor_add_pipoint.arn,
      aws_sqs_queue.sqs_dataextractor-duplicated-pipoint.arn,
      aws_sqs_queue.sqs_dataextractor_duplicated_pipoint_group.arn,
      aws_sqs_queue.sqs_dataextractor_general_data.arn,
      aws_sqs_queue.sqs_dataextractor_remove_pipoint.arn,
      aws_sqs_queue.sqs_dataextractor-template-consitency-report.arn,
      aws_sqs_queue.sqs_dataextractor_update_pipoint.arn,
      aws_sqs_queue.sqs_monitor_job.arn,
      aws_sqs_queue.sqs_monitor-job_error.arn,
      aws_sqs_queue.sqs_dataworkflow-job.arn
    ]
  }
}

resource "aws_iam_role_policy" "ecs_task_ecr_access" {
  role = aws_iam_role.ecs_task_execution_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:GetLifecyclePolicy",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:ListTagsForResource",
          "ecr:DescribeImageScanFindings",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "events:PutRule",
          "events:PutTargets",
          "events:DescribeRule",
          "events:ListTargetsByRule"
        ]
        Resource = "*"

        Condition = {
          StringEquals = {
            "aws:sourceVpce" = "vpce-088eaa7e1ed0b0fec",
            "aws:sourceVpc"  = "vpc-02c19404cee0b6417"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_ecr_access" {
  role = aws_iam_role.iam_lambda.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:GetLifecyclePolicy",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:ListTagsForResource",
          "ecr:DescribeImageScanFindings",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "events:PutRule",
          "events:PutTargets",
          "events:DescribeRule",
          "events:ListTargetsByRule"
        ]
        Resource = "*"

        Condition = {
          StringEquals = {
            "aws:sourceVpce" = "vpce-088eaa7e1ed0b0fec",
            "aws:sourceVpc"  = "vpc-02c19404cee0b6417"
          }
        }
      }
    ]
  })
}
