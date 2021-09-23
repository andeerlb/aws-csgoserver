resource "aws_iam_policy" "csgoserver_s3_access" {
  name = "${var.prefix_name}_s3_access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
            "s3:ListBucket", 
            "s3:GetBucketAcl",
            "s3:GetObject",
            "s3:GetObjectAcl",
            "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${var.bucket_s3_backup_name}/*"
      },
    ]
  })
}

resource "aws_iam_role" "csgoserver" {
  name = local.name_with_prefix

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [aws_iam_policy.csgoserver_s3_access.arn]

  tags = merge({}, var.default_tags)
}
