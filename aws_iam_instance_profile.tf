resource "aws_iam_instance_profile" "csgoserver" {
    name  = local.name_with_prefix
    role = aws_iam_role.csgoserver.name
}