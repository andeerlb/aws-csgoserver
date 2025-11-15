# Shared Security Group across all CS2 servers
# This SG is created once and shared by all workspaces
resource "aws_security_group" "cs2" {
  name        = "cs2-shared-gameserver-sg"
  description = "Allow CS2 gameserver traffic (shared by all servers)"
  vpc_id      = module.vpc_cs2.id

  tags = merge({}, var.default_tags)

  lifecycle {
    ignore_changes = [name]
  }
}