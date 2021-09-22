resource "aws_security_group" "csgo" {
  name        = "csgoserver"
  description = "Allow csgoserver traffic"
  vpc_id      = module.vpc_csgo.id

  tags = merge({}, var.default_tags)
}