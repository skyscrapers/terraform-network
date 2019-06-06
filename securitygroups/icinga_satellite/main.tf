terraform {
  required_version = ">= 0.12"
}

resource "aws_security_group" "sg_icinga_satellite" {
  name        = "sg_icinga_satellite_${var.project}_${var.environment}"
  description = "Icinga Satellite Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.project}-${var.environment}-sg_icinga_sattelite"
    Environment = var.environment
    Project     = var.project
  }
}

# Allow incoming NRPE check from icinga2
resource "aws_security_group_rule" "icinga_nrpe_into_tools01" {
  type              = "ingress"
  security_group_id = aws_security_group.sg_icinga_satellite.id
  from_port         = "5666"
  to_port           = "5666"
  protocol          = "tcp"
  cidr_blocks       = [var.icinga_master_ip]
}

resource "aws_security_group_rule" "icinga_into_tools01" {
  type              = "ingress"
  security_group_id = aws_security_group.sg_icinga_satellite.id
  from_port         = "5667"
  to_port           = "5667"
  protocol          = "tcp"
  cidr_blocks       = [var.icinga_master_ip]
}

resource "aws_security_group_rule" "icinga_outside1_from_tools01" {
  type              = "egress"
  security_group_id = aws_security_group.sg_icinga_satellite.id
  from_port         = "5665"
  to_port           = "5665"
  protocol          = "tcp"
  cidr_blocks       = [var.icinga_master_ip]
}

resource "aws_security_group_rule" "icinga_outside2_from_tools01" {
  type              = "egress"
  security_group_id = aws_security_group.sg_icinga_satellite.id
  from_port         = "6379"
  to_port           = "6379"
  protocol          = "tcp"
  cidr_blocks       = [var.icinga_master_ip]
}

resource "aws_security_group_rule" "icinga_outside3_from_tools01" {
  type              = "egress"
  security_group_id = aws_security_group.sg_icinga_satellite.id
  from_port         = "9418"
  to_port           = "9418"
  protocol          = "tcp"
  cidr_blocks       = [var.icinga_master_ip]
}

resource "aws_security_group_rule" "nrpe_satellite_to_instances" {
  count                    = length(var.internal_sg_id) > 0 ? 1 : 0
  type                     = "egress"
  security_group_id        = aws_security_group.sg_icinga_satellite.id
  from_port                = "5666"
  to_port                  = "5666"
  protocol                 = "tcp"
  source_security_group_id = var.internal_sg_id
}

resource "aws_security_group_rule" "nrpe_instances_to_satellite" {
  count                    = length(var.internal_sg_id) > 0 ? 1 : 0
  type                     = "ingress"
  security_group_id        = var.internal_sg_id
  from_port                = "5666"
  to_port                  = "5666"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg_icinga_satellite.id
}
