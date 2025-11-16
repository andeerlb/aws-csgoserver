resource "aws_iam_role" "cs2server" {
  for_each = var.servers
  
  name = "cs2server_${each.value.server_name}_role"

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

  tags = merge({
    ServerKey  = each.key
    ServerName = each.value.server_name
  }, var.default_tags)
}

# IAM Policy for S3 backup bucket access
resource "aws_iam_role_policy" "cs2server_s3_backup" {
  for_each = var.servers
  
  name = "cs2server_${each.value.server_name}_s3_backup_policy"
  role = aws_iam_role.cs2server[each.key].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.s3_serverfiles_backup}",
          "arn:aws:s3:::${var.s3_serverfiles_backup}/*"
        ]
      }
    ]
  })
}
