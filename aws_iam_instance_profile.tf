resource "aws_iam_instance_profile" "cs2server" {
  name = local.name_with_prefix
  role = aws_iam_role.cs2server.name
}