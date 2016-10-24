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

module "public_subnets" {
  source             = "../subnets"
  num_subnets        = "${var.amount_public_subnets}"
  availability_zones = "${var.availability_zones}"
  name               = "public"
  cidr               = "${var.cidr_block}"
  netnum             = 0
  vpc_id             = "${aws_vpc.main.id}"
  aws_region         = "${var.aws_region}"
  environment        = "${var.environment}"
  project            = "${var.project}"
}

module "app_subnets" {
  source      = "../subnets"
  num_subnets = "${var.amount_app_subnets}"
  name        = "app"
  cidr        = "${var.cidr_block}"
  netnum      = 10
  vpc_id      = "${aws_vpc.main.id}"
  aws_region  = "${var.aws_region}"
  environment = "${var.environment}"
  project     = "${var.project}"
}

module "db_subnets" {
  source      = "../subnets"
  num_subnets = "${var.amount_db_subnets}"
  name        = "db"
  cidr        = "${var.cidr_block}"
  netnum      = 20
  vpc_id      = "${aws_vpc.main.id}"
  aws_region  = "${var.aws_region}"
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
