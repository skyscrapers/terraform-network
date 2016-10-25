data "aws_availability_zones" "available" {
  state="available"
}

resource "aws_subnet" "subnets" {
  count             = "${var.num_subnets}"
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${cidrsubnet(var.cidr,var.newbits,var.netnum+count.index)}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"

  tags {
    Name        = "${var.project}-${var.name}${var.tag}-${element(data.aws_availability_zones.available.names, count.index)}"
    tags        = "${var.tag}"
    Environment = "${var.environment}"
    Project     = "${var.project}"
  }
}
