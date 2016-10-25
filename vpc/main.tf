# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name        = "${var.project} VPC"
    Environment = "${var.environment}"
    Project     = "${var.project}"
  }
}

module "public_nat-bastion_subnets" {
  source             = "../subnets"
  num_subnets        = "${var.amount_public_nat-bastion_subnets}"
  name               = "public_nat-bastion"
  cidr               = "${var.cidr_block}"
  netnum             = "${var.netnum_public_nat-bastion}"
  vpc_id             = "${aws_vpc.main.id}"
  environment        = "${var.environment}"
  project            = "${var.project}"
}

module "public_lb_subnets" {
  source             = "../subnets"
  num_subnets        = "${var.amount_public_lb_subnets}"
  name               = "public_lb"
  cidr               = "${var.cidr_block}"
  netnum             = "${var.netnum_public_lb}"
  vpc_id             = "${aws_vpc.main.id}"
  environment        = "${var.environment}"
  project            = "${var.project}"
}

module "app_subnets" {
  source      = "../subnets"
  num_subnets = "${var.amount_app_subnets}"
  name        = "app"
  cidr        = "${var.cidr_block}"
  netnum      = "${var.netnum_app}"
  vpc_id      = "${aws_vpc.main.id}"
  environment = "${var.environment}"
  project     = "${var.project}"
}

module "db_subnets" {
  source      = "../subnets"
  num_subnets = "${var.amount_db_subnets}"
  name        = "db"
  cidr        = "${var.cidr_block}"
  netnum      = "${var.netnum_db}"
  vpc_id      = "${aws_vpc.main.id}"
  environment = "${var.environment}"
  project     = "${var.project}"
}

# Create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "${var.project} internet gateway"
    Environment = "${var.environment}"
    Project     = "${var.project}"
  }
}
