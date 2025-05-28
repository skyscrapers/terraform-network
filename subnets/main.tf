data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_route_table" "rtbs" {
  for_each       = toset(var.route_tables)
  route_table_id = each.value
  vpc_id         = var.vpc_id
}

locals {
  availability_zones = var.availability_zones != null ? var.availability_zones : data.aws_availability_zones.available.names

  # We expect either a single route table or a route tables per AZ.
  route_table_per_az = {
    for rtb in data.aws_route_table.rtbs :
    try(rtb.tags["AvailabilityZone"], "single") => rtb.id
  }
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
  for_each = var.num_route_tables > 0 ? aws_subnet.subnets : {}

  # Make sure to use the correct route table based on the AZs
  subnet_id      = each.value["id"]
  route_table_id = var.num_route_tables > 1 ? local.route_table_per_az[each.value["availability_zone"]] : var.route_tables[0]
}
