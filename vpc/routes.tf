# Create public_nat-bastion route table
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = "${merge("${var.tags}",map("Name", "${var.project} public route table", "Environment", "${var.environment}", "Project", "${var.project}"))}"
}

resource "aws_route_table_association" "public_lb_hosts" {
  count          = "${var.amount_public_lb_subnets}"
  subnet_id      = "${element(module.public_lb_subnets.ids, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public_nat-bastion_hosts" {
  count          = "${var.amount_public_nat-bastion_subnets}"
  subnet_id      = "${element(module.public_nat-bastion_subnets.ids, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

# Create route table
resource "aws_route_table" "private" {
  count  = "${var.number_private_rt}"
  vpc_id = "${aws_vpc.main.id}"

  tags = "${merge("${var.tags}",map("Name", "${var.project} private route table", "Environment", "${var.environment}", "Project", "${var.project}"))}"
}

# Associate route table to subnets
resource "aws_route_table_association" "private_app" {
  count          = "${var.amount_private_app_subnets}"
  subnet_id      = "${element(module.private_app_subnets.ids, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

# Associate route table to subnets
resource "aws_route_table_association" "private_db" {
  count          = "${var.amount_private_db_subnets}"
  subnet_id      = "${element(module.private_db_subnets.ids, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

# Associate route table to subnets
resource "aws_route_table_association" "private_management" {
  count          = "${var.amount_private_management_subnets}"
  subnet_id      = "${element(module.private_management_subnets.ids, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
