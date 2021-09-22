resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 0
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.csgo.id 
  cidr_blocks = ["189.27.213.227/32"]
}

resource "aws_security_group_rule" "all_egress" {
    type              = "egress"
    from_port = 0
    to_port           = 0
    protocol          = "-1"
    security_group_id = aws_security_group.csgo.id 
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
}