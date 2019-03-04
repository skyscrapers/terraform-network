# Create public_nat-bastion route table
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags = "${merge("${var.tags}",map("Name", "${var.project} public route table", "Environment", "${var.environment}", "Project", "${var.project}"))}"
}

resource "aws_route" "public" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}

# Create route table
resource "aws_route_table" "private" {
  count  = "${var.number_private_rt}"
  vpc_id = "${aws_vpc.main.id}"

  tags = "${merge("${var.tags}",map("Name", "${var.project} private route table", "Environment", "${var.environment}", "Project", "${var.project}"))}"
}
