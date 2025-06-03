locals {
  # Either use the specified AZ list or fall back to the available AZs. We will use a maximum of 3 AZs.
  availability_zones = slice(coalescelist(var.availability_zones, data.aws_availability_zones.available.names), 0, 3)
  nat_gateway_count  = var.enable_nat_gateway ? var.single_nat_gateway ? 1 : length(local.availability_zones) : 0
}

data "aws_availability_zones" "available" {
  state = "available"
}

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

module "public_nat_subnets" {
  source             = "../subnets"
  name               = "${var.name}-public-nat"
  availability_zones = slice(local.availability_zones, 0, local.nat_gateway_count)
  cidr               = var.cidr_block
  netnum             = var.netnum_public_nat
  vpc_id             = aws_vpc.main.id
  route_tables       = aws_route_table.public.*.id

  tags = merge(var.extra_tags_public_nat, var.tags, {
    visibility = "public"
    role       = "nat"
  })
}

module "public_lb_subnets" {
  source             = "../subnets"
  name               = "${var.name}-public-lb"
  availability_zones = var.enable_public_lb_subnets ? local.availability_zones : []
  cidr               = var.cidr_block
  netnum             = var.netnum_public_lb
  vpc_id             = aws_vpc.main.id
  route_tables       = aws_route_table.public.*.id

  tags = merge(var.extra_tags_public_lb, var.tags, {
    visibility = "public"
    role       = "lb"
  })
}

module "private_app_subnets" {
  source             = "../subnets"
  name               = "${var.name}-private-app"
  availability_zones = var.enable_private_app_subnets ? local.availability_zones : []
  cidr               = var.cidr_block
  netnum             = var.netnum_private_app
  vpc_id             = aws_vpc.main.id
  route_tables       = aws_route_table.private.*.id

  tags = merge(var.extra_tags_private_app, var.tags, {
    visibility = "private"
    role       = "app"
  })
}

module "private_db_subnets" {
  source             = "../subnets"
  name               = "${var.name}-private-db"
  availability_zones = var.enable_private_db_subnets ? local.availability_zones : []
  cidr               = var.cidr_block
  netnum             = var.netnum_private_db
  vpc_id             = aws_vpc.main.id
  route_tables       = aws_route_table.private.*.id

  tags = merge(var.extra_tags_private_db, var.tags, {
    visibility = "private"
    role       = "db"
  })
}

module "private_management_subnets" {
  source             = "../subnets"
  name               = "${var.name}-private-management"
  availability_zones = var.enable_private_management_subnets ? local.availability_zones : []
  cidr               = var.cidr_block
  netnum             = var.netnum_private_management
  vpc_id             = aws_vpc.main.id
  route_tables       = aws_route_table.private.*.id

  tags = merge(var.extra_tags_private_management, var.tags, {
    visibility = "private"
    role       = "management"
  })
}
