data "aws_vpc" "vpc_info" {
  id = var.vpc_id
}

# Create common security group
resource "aws_security_group" "sg_all" {
  name        = var.name
  description = "General security used on all servers"
  vpc_id      = var.vpc_id
}

# Allow NTP connections to the outside
resource "aws_security_group_rule" "sg_bastion_out_ntp" {
  type              = "egress"
  security_group_id = aws_security_group.sg_all.id
  from_port         = 123
  to_port           = 123
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Allow HTTP connections to the outside
resource "aws_security_group_rule" "sg_bastion_out_http" {
  type              = "egress"
  security_group_id = aws_security_group.sg_all.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Allow HTTPS connections to the outside
resource "aws_security_group_rule" "sg_bastion_out_https" {
  type              = "egress"
  security_group_id = aws_security_group.sg_all.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Allow incoming ping within the VPC
resource "aws_security_group_rule" "sg_all_ingress_ping" {
  type              = "ingress"
  security_group_id = aws_security_group.sg_all.id
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "icmp"
  cidr_blocks       = [data.aws_vpc.vpc_info.cidr_block]
}

# Allow outgoing ping within the VPC
resource "aws_security_group_rule" "sg_all_egress_ping" {
  type              = "egress"
  security_group_id = aws_security_group.sg_all.id
  from_port         = "-1"
  to_port           = "-1"
  protocol          = "icmp"
  cidr_blocks       = [data.aws_vpc.vpc_info.cidr_block]
}
