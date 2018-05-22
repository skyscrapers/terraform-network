terraform {
  required_version = ">= 0.9.11"
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "subnets" {
  count             = "${var.num_subnets}"
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${cidrsubnet(var.cidr,var.newbits,var.netnum+count.index)}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"

  tags = "${merge("${var.tags}",map("Name", "${var.project}-${var.visibility}-${var.role}-${element(data.aws_availability_zones.available.names, count.index)}", "Environment", "${var.environment}", "Project", "${var.project}", "Role", "${var.role}", "Visibility", "${var.visibility}", "AvailabilityZone", element(data.aws_availability_zones.available.names, count.index)))}"
}

resource "aws_route_table_association" "subnet_association" {
  count          = "${var.num_route_tables >0 ? "${var.num_subnets}" : 0 }"
  subnet_id      = "${element(aws_subnet.subnets.*.id, count.index)}"
  route_table_id = "${element(var.route_tables, count.index)}"
}
