output "vpc_id" {
  value = "${aws_vpc.main.id}"
}
output "public_nat-bastion" {
  value = "${module.public_nat-bastion_subnets.ids}"
}
output "public_lb_subnets" {
  value = "${module.public_lb_subnets.ids}"
}

output "app_subnets" {
  value = "${module.app_subnets.ids}"
}

output "db_subnets" {
  value = "${module.db_subnets.ids}"
}

output "private_rts" {
  value = ["${aws_route_table.private.*.id}"]
}
