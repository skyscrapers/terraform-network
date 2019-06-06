terraform {
  required_version = ">= 0.12"
}

# Create common security group
resource "aws_security_group" "sg_web_public" {
  name        = "sg_web_public_${var.project}_${var.environment}"
  description = "General security group to allow incoming web traffic from everywhere"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.project}-${var.environment}-sg_web_public"
    Environment = var.environment
    Project     = var.project
  }
}

# Accept incoming http connections
resource "aws_security_group_rule" "sg_host_in_http" {
  type              = "ingress"
  security_group_id = aws_security_group.sg_web_public.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Accept incoming https connections
resource "aws_security_group_rule" "sg_host_in_https" {
  type              = "ingress"
  security_group_id = aws_security_group.sg_web_public.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
