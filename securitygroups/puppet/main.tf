terraform {
  required_version = ">= 0.12"
}

resource "aws_security_group" "sg_puppet" {
  name        = "sg_puppet_${var.project}_${var.environment}"
  description = "Puppet Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.project}-${var.environment}-sg_puppet"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_security_group_rule" "sg_tools_puppet" {
  security_group_id = aws_security_group.sg_puppet.id
  type              = "egress"
  from_port         = "8140"
  to_port           = "8140"
  protocol          = "tcp"
  cidr_blocks       = [var.puppet_master_ip]
}
