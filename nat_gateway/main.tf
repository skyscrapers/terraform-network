resource "aws_eip" "nat_gateway" {
  count = var.number_nat_gateways
  vpc   = true
}

data "aws_subnet" "ngw_subnets" {
  count = var.number_nat_gateways
  id    = var.public_subnets[count.index]
}

resource "aws_nat_gateway" "gateway" {
  count         = var.number_nat_gateways
  allocation_id = aws_eip.nat_gateway[count.index].id
  subnet_id     = var.public_subnets[count.index]

  tags = merge(
    var.tags,
    {
      "Name" = data.aws_subnet.ngw_subnets[count.index].availability_zone
    },
  )
}

resource "aws_route" "r" {
  count                  = var.number_nat_gateways
  route_table_id         = element(var.private_route_tables, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.gateway.*.id, count.index)
}
