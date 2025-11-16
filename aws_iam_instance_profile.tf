resource "aws_iam_instance_profile" "cs2server" {
  for_each = var.servers
  
  name = "cs2server_${each.value.server_name}_profile"
  role = aws_iam_role.cs2server[each.key].name
}