resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.cs2.id
  cidr_blocks       = var.ssh_allowed_cidrs
}

resource "aws_security_group_rule" "game_rcon_tcp" {
  type              = "ingress"
  from_port         = 27015
  to_port           = 27015
  protocol          = "tcp"
  security_group_id = aws_security_group.cs2.id
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "game_rcon_udp" {
  type              = "ingress"
  from_port         = 27015
  to_port           = 27015
  protocol          = "udp"
  security_group_id = aws_security_group.cs2.id
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "game_rcon_tv" {
  type              = "ingress"
  from_port         = 27020
  to_port           = 27020
  protocol          = "tcp"
  security_group_id = aws_security_group.cs2.id
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "game_rcon_client" {
  type              = "ingress"
  from_port         = 27005
  to_port           = 27005
  protocol          = "udp"
  security_group_id = aws_security_group.cs2.id
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.cs2.id
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}