resource "aws_security_group" "csgo" {
  name        = "${var.prefix_name} - gameserver"
  description = "Allow gameserver traffic"
  vpc_id      = module.vpc_csgo.id

  tags = merge({}, var.default_tags)
}