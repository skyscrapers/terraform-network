terraform {
  required_version = "> 0.8.0"
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = "${merge("${var.tags}",map("Name", "${var.project} VPC", "Environment", "${var.environment}", "Project", "${var.project}"))}"
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
  tags        = "${var.tags}"
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
  tags        = "${var.tags}"
}

module "private_app_subnets" {
  source      = "../subnets"
  num_subnets = "${var.amount_private_app_subnets}"
  name        = "private_app"
  cidr        = "${var.cidr_block}"
  netnum      = "${var.netnum_private_app}"
  vpc_id      = "${aws_vpc.main.id}"
  environment = "${var.environment}"
  project     = "${var.project}"
  tags        = "${var.tags}"
}

module "private_db_subnets" {
  source      = "../subnets"
  num_subnets = "${var.amount_private_db_subnets}"
  name        = "private_db"
  cidr        = "${var.cidr_block}"
  netnum      = "${var.netnum_private_db}"
  vpc_id      = "${aws_vpc.main.id}"
  environment = "${var.environment}"
  project     = "${var.project}"
  tags        = "${var.tags}"
}

module "private_management_subnets" {
  source      = "../subnets"
  num_subnets = "${var.amount_private_management_subnets}"
  name        = "private_management"
  cidr        = "${var.cidr_block}"
  netnum      = "${var.netnum_private_management}"
  vpc_id      = "${aws_vpc.main.id}"
  environment = "${var.environment}"
  project     = "${var.project}"
  tags        = "${var.tags}"
}


# Create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = "${merge(map("Name", "${var.project} internet gateway", "Environment", "${var.environment}", "Project", "${var.project}"),"${var.tags}")}"
}
