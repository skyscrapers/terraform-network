resource "aws_subnet" "subnets" {
  count = length(var.availability_zones)

  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet(var.cidr, var.newbits, var.netnum + count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(var.tags, {
    "Name"             = "${var.name}-${var.availability_zones[count.index]}"
    "AvailabilityZone" = var.availability_zones[count.index]
  })
}

resource "aws_route_table_association" "subnet_association" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.subnets.*.id, count.index)
  route_table_id = element(var.route_tables, count.index)
}
