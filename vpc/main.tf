resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    merge(var.extra_tags_vpc, var.tags),
    {
      "Name"        = "${var.project} ${var.environment} VPC"
      "Environment" = var.environment
      "Project"     = var.project
    },
  )
}

module "public_nat-bastion_subnets" {
  source           = "../subnets"
  num_subnets      = var.amount_public_nat-bastion_subnets
  visibility       = "public"
  role             = "nat-bastion"
  cidr             = var.cidr_block
  netnum           = var.netnum_public_nat-bastion
  vpc_id           = aws_vpc.main.id
  environment      = var.environment
  project          = var.project
  tags             = merge(var.extra_tags_public_nat-bastion, var.tags)
  route_tables     = aws_route_table.public.*.id
  num_route_tables = "1"
}

module "public_lb_subnets" {
  source           = "../subnets"
  num_subnets      = var.amount_public_lb_subnets
  visibility       = "public"
  role             = "lb"
  cidr             = var.cidr_block
  netnum           = var.netnum_public_lb
  vpc_id           = aws_vpc.main.id
  environment      = var.environment
  project          = var.project
  tags             = merge(var.extra_tags_public_lb, var.tags)
  route_tables     = aws_route_table.public.*.id
  num_route_tables = "1"
}

module "private_app_subnets" {
  source           = "../subnets"
  num_subnets      = var.amount_private_app_subnets
  visibility       = "private"
  role             = "app"
  cidr             = var.cidr_block
  netnum           = var.netnum_private_app
  vpc_id           = aws_vpc.main.id
  environment      = var.environment
  project          = var.project
  tags             = merge(var.extra_tags_private_app, var.tags)
  route_tables     = aws_route_table.private.*.id
  num_route_tables = var.number_private_rt
}

module "private_db_subnets" {
  source           = "../subnets"
  num_subnets      = var.amount_private_db_subnets
  visibility       = "private"
  role             = "db"
  cidr             = var.cidr_block
  netnum           = var.netnum_private_db
  vpc_id           = aws_vpc.main.id
  environment      = var.environment
  project          = var.project
  tags             = merge(var.extra_tags_private_db, var.tags)
  route_tables     = aws_route_table.private.*.id
  num_route_tables = var.number_private_rt
}

module "private_management_subnets" {
  source           = "../subnets"
  num_subnets      = var.amount_private_management_subnets
  visibility       = "private"
  role             = "management"
  cidr             = var.cidr_block
  netnum           = var.netnum_private_management
  vpc_id           = aws_vpc.main.id
  environment      = var.environment
  project          = var.project
  tags             = merge(var.extra_tags_private_management, var.tags)
  route_tables     = aws_route_table.private.*.id
  num_route_tables = var.number_private_rt
}

# Create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.extra_tags_vpc,
    var.tags,
    {
      "Name"        = "${var.project} ${var.environment} VPC"
      "Environment" = var.environment
      "Project"     = var.project
    },
  )
}
