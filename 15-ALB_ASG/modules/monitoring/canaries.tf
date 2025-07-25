module "spring_boot_heartbeat_s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.2.0"

  bucket = "${var.name_prefix}-heartbeat-s3-bucket"

  force_destroy = true


  versioning = {
    status     = true
    mfa_delete = false
  }
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  object_ownership = "BucketOwnerEnforced"

  tags = var.common_tags




}


#Iam Role for Canary

resource "aws_iam_role" "spring_boot_canary_execution_role" {
  name = "${var.name_prefix}-canary-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
    }
  )
  tags = var.common_tags



}

#Custom Policy For S3 access
resource "aws_iam_role_policy" "spring_boot_canary_s3_policy" {
  name = "${var.name_prefix}-canary-s3-policy"
  role = aws_iam_role.spring_boot_canary_execution_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      ##S3 permissions
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject",
          "s3:GetBucketLocation",
          "s3:ListAllMyBuckets"
        ]
        Resource = [
          module.spring_boot_heartbeat_s3_bucket.s3_bucket_arn,
          "${module.spring_boot_heartbeat_s3_bucket.s3_bucket_arn}/*"

        ]
      },
      # Cloudwatch Metrics Permissions
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "cloudwatch:namespace" = "CloudWatchSynthetics"
          }
        }
      },
      #X-Ray Permissions
      {
        Effect = "Allow"
        Action = [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords"
        ]
        Resource = "*"
      }

    ]
  })
}



resource "aws_synthetics_canary" "spring-boot-app-heartbeat" {
  name                 = "${var.name_prefix}-heartbeat"
  artifact_s3_location = "s3://${module.spring_boot_heartbeat_s3_bucket.s3_bucket_id}/"
  execution_role_arn   = aws_iam_role.spring_boot_canary_execution_role.arn
  handler              = "spring_heartbeat.handler"
  runtime_version      = "syn-nodejs-playwright-2.0"
  start_canary         = true
  schedule {
    expression = "rate(1 minute)"
  }

  run_config {
    timeout_in_seconds = 60
    memory_in_mb       = 960

  }

  zip_file                 = data.archive_file.spring_heartbeat_script.output_path
  failure_retention_period = 30
  success_retention_period = 30
  tags                     = var.common_tags



}

data "archive_file" "spring_heartbeat_script" {
  type        = "zip"
  output_path = "/tmp/heartbeat.zip"
  source {
    content = templatefile("${path.module}/scripts/spring_heartbeat.js", {
      endpoint_url = "https://${var.spring_boot_endpoint_url}"
    })
    filename = "nodejs/node_modules/spring_heartbeat.js"
  }
}
