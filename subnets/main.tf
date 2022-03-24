data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zones = var.availability_zones != null ? var.availability_zones : data.aws_availability_zones.available.names
}

resource "aws_subnet" "subnets" {
  count                   = var.num_subnets
  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet(var.cidr, var.newbits, var.netnum + count.index)
  availability_zone       = local.availability_zones[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    var.tags,
    {
      "Name"             = "${var.name}-${local.availability_zones[count.index]}"
      "AvailabilityZone" = local.availability_zones[count.index]
    },
  )
}

resource "aws_route_table_association" "subnet_association" {
  count          = var.num_route_tables > 0 ? var.num_subnets : 0
  subnet_id      = element(aws_subnet.subnets.*.id, count.index)
  route_table_id = element(var.route_tables, count.index)
}
