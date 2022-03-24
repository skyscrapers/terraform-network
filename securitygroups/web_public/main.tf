# Create common security group
resource "aws_security_group" "sg_web_public" {
  name        = var.name
  description = "General security group to allow incoming web traffic from everywhere"
  vpc_id      = var.vpc_id
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
