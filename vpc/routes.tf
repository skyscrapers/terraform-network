## PUBLIC

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    "Name" = var.name
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    "Name" = "${var.name}-public"
  })
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

## PRIVATE

resource "aws_eip" "nat_gateway" {
  count  = local.nat_gateway_count
  domain = "vpc"

  tags = merge(var.tags, {
    "Name"             = "${var.name}-natgw-${module.public_nat_subnets.azs[count.index]}"
    "AvailabilityZone" = module.public_nat_subnets.azs[count.index]
  })
}

resource "aws_nat_gateway" "gateway" {
  count = local.nat_gateway_count

  allocation_id = aws_eip.nat_gateway[count.index].id
  subnet_id     = module.public_nat_subnets.ids[count.index]

  tags = merge(var.tags, {
    "Name"             = "${var.name}-${module.public_nat_subnets.azs[count.index]}"
    "AvailabilityZone" = module.public_nat_subnets.azs[count.index]
  })
}

resource "aws_route_table" "private" {
  # Always make sure to provide at least 1 private route table
  count  = local.nat_gateway_count > 0 ? local.nat_gateway_count : 1
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    "Name" = local.nat_gateway_count > 1 ? "${var.name}-private-${module.public_nat_subnets.azs[count.index]}" : "${var.name}-private"
    }, local.nat_gateway_count <= 1 ? {} : {
    "AvailabilityZone" = module.public_nat_subnets.azs[count.index]
  })
}

resource "aws_route" "private" {
  count                  = local.nat_gateway_count
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gateway[count.index].id
}
