# Create common security group
resource "aws_security_group" "sg_all" {
  name        = "sg_all_${var.project}_${var.environment}"
  description = "General security used on all servers"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "${var.project}-${var.environment}-sg_all"
    Environment = "${var.environment}"
    Project     = "${var.project}"
  }
}

# Allow NTP connections to the outside
resource "aws_security_group_rule" "sg_bastion_out_ntp" {
  type              = "egress"
  security_group_id = "${aws_security_group.sg_all.id}"
  from_port         = 123
  to_port           = 123
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Allow HTTP connections to the outside
resource "aws_security_group_rule" "sg_bastion_out_https" {
  type              = "egress"
  security_group_id = "${aws_security_group.sg_all.id}"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}


# Allow HTTPS connections to the outside
resource "aws_security_group_rule" "sg_bastion_out_https" {
  type              = "egress"
  security_group_id = "${aws_security_group.sg_all.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Allow puppet connections to the outside
resource "aws_security_group_rule" "sg_bastion_out_https" {
  type              = "egress"
  security_group_id = "${aws_security_group.sg_all.id}"
  from_port         = 8140
  to_port           = 8140
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
