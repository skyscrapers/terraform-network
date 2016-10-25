# Create bastion route table
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name        = "${var.project} public route table"
    Environment = "${var.environment}"
    Project     = "${var.project}"
  }
}

# Associate route table to bastion subnets
resource "aws_route_table_association" "public_hosts" {
  count          = "${var.amount_public_subnets}"
  subnet_id      = "${element(module.public_subnets.ids, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}
resource "aws_route_table_association" "bastion_hosts" {
  count          = "${var.amount_bastion_subnets}"
  subnet_id      = "${element(module.bastion_subnets.ids, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}
# Create route table
resource "aws_route_table" "private" {
  count  = "${var.number_private_rt}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "${var.project} private route table"
    Environment = "${var.environment}"
    Project     = "${var.project}"
  }
}

# Associate route table to subnets
resource "aws_route_table_association" "app" {
  count          = "${var.amount_app_subnets}"
  subnet_id      = "${element(module.app_subnets.ids, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

# Associate route table to subnets
resource "aws_route_table_association" "db" {
  count          = "${var.amount_db_subnets}"
  subnet_id      = "${element(module.db_subnets.ids, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
