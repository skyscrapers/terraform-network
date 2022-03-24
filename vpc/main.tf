resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.extra_tags_vpc,
    var.tags,
    {
      "Name" = var.name
    },
  )
}

module "public_nat-bastion_subnets" {
  source             = "../subnets"
  name               = "${var.name}-public-nat-bastion"
  availability_zones = var.availability_zones
  num_subnets        = var.amount_public_nat-bastion_subnets
  cidr               = var.cidr_block
  netnum             = var.netnum_public_nat-bastion
  vpc_id             = aws_vpc.main.id
  route_tables       = aws_route_table.public.*.id
  num_route_tables   = 1

  tags = merge(var.extra_tags_public_nat-bastion, var.tags, {
    visibility = "public"
    role       = "nat-bastion"
  })
}

module "public_lb_subnets" {
  source             = "../subnets"
  name               = "${var.name}-public-lb"
  availability_zones = var.availability_zones
  num_subnets        = var.amount_public_lb_subnets
  cidr               = var.cidr_block
  netnum             = var.netnum_public_lb
  vpc_id             = aws_vpc.main.id
  route_tables       = aws_route_table.public.*.id
  num_route_tables   = 1

  tags = merge(var.extra_tags_public_lb, var.tags, {
    visibility = "public"
    role       = "lb"
  })
}

module "private_app_subnets" {
  source             = "../subnets"
  name               = "${var.name}-private-app"
  availability_zones = var.availability_zones
  num_subnets        = var.amount_private_app_subnets
  cidr               = var.cidr_block
  netnum             = var.netnum_private_app
  vpc_id             = aws_vpc.main.id
  route_tables       = aws_route_table.private.*.id
  num_route_tables   = var.number_private_rt

  tags = merge(var.extra_tags_private_app, var.tags, {
    visibility = "private"
    role       = "app"
  })
}

module "private_db_subnets" {
  source             = "../subnets"
  name               = "${var.name}-private-db"
  availability_zones = var.availability_zones
  num_subnets        = var.amount_private_db_subnets
  cidr               = var.cidr_block
  netnum             = var.netnum_private_db
  vpc_id             = aws_vpc.main.id
  route_tables       = aws_route_table.private.*.id
  num_route_tables   = var.number_private_rt

  tags = merge(var.extra_tags_private_db, var.tags, {
    visibility = "private"
    role       = "db"
  })
}

module "private_management_subnets" {
  source             = "../subnets"
  name               = "${var.name}-private-management"
  availability_zones = var.availability_zones
  num_subnets        = var.amount_private_management_subnets
  cidr               = var.cidr_block
  netnum             = var.netnum_private_management
  vpc_id             = aws_vpc.main.id
  route_tables       = aws_route_table.private.*.id
  num_route_tables   = var.number_private_rt

  tags = merge(var.extra_tags_private_management, var.tags, {
    visibility = "private"
    role       = "management"
  })
}

# Create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      "Name" = var.name
    },
  )
}
