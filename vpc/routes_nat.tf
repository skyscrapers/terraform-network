# Create public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      "Name" = "${var.name}-public"
    },
  )
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

# Create private route tables
resource "aws_route_table" "private" {
  count  = local.nat_gateway_count
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      "Name" = local.nat_gateway_count > 1 ? "${var.name}-private-${element(local.availability_zones, count.index)}" : "${var.name}-private"
    },
  )
}

resource "aws_eip" "nat_gateway" {
  count  = local.nat_gateway_count
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      "Name" = "${var.name}-natgw-${element(local.availability_zones, count.index)}"
    },
  )
}

resource "aws_nat_gateway" "gateway" {
  count = local.nat_gateway_count

  allocation_id = aws_eip.nat_gateway[count.index].id
  subnet_id     = element(module.public_nat_subnets.*.ids, count.index)

  tags = merge(
    var.tags,
    {
      "Name" = "${var.name}-${element(local.availability_zones, count.index)}"
    },
  )
}

resource "aws_route" "r" {
  count                  = local.nat_gateway_count
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gateway[count.index].id
}
