resource "aws_security_group" "sg" {
  name        = "sg_main_${var.project}_${var.environment}"
  description = "Basic Security Group"
  vpc_id      = "${aws_vpc.main.id}"

  # Allow incoming ICMP from CIDR block (for debug)
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.cidr_block}"]
  }

  # Allow incoming NRPE check from icinga2
  ingress {
    from_port   = 5666
    to_port     = 5666
    protocol    = "tcp"
    cidr_blocks = ["${var.icinga_ip}"]
  }

  # Allow HTTP connections to the outside
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow NTP connections to the outside
  egress {
    from_port   = 123
    to_port     = 123
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS connections to the outside
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 8140
    to_port     = 8140
    protocol    = "tcp"
    cidr_blocks = ["${var.puppetmaster_ip}"]
  }

  tags {
    Name        = "${var.project}-${var.environment}-sg-basic"
    Environment = "${var.environment}"
    Project     = "${var.project}"
  }
}
