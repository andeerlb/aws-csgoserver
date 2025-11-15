resource "aws_security_group" "cs2" {
  name        = "${var.prefix_name} - gameserver"
  description = "Allow CS2 gameserver traffic"
  vpc_id      = module.vpc_cs2.id

  tags = merge({}, var.default_tags)
}