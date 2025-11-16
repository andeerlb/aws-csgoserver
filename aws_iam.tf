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

  managed_policy_arns = []

  tags = merge({
    ServerKey  = each.key
    ServerName = each.value.server_name
  }, var.default_tags)
}
