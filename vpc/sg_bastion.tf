resource "aws_security_group" "bastion_sg" {
  name        = "sg_bastion_${var.project}_${var.environment}"
  description = "Tools Security Group"
  vpc_id      = "${aws_vpc.main.id}"

  # Allow incoming ICMP check from icinga2
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.cidr_block}", "${var.icinga_ip}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5666
    to_port     = 5666
    protocol    = "tcp"
    cidr_blocks = ["${var.icinga_ip}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.project}-${var.environment}-sg-bastion"
    Environment = "${var.environment}"
    Project     = "${var.project}"
  }
}
