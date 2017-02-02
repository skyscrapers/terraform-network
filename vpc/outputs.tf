output "vpc_id" {
  value = "${aws_vpc.main.id}"
}
output "public_nat-bastion" {
  value = "${module.public_nat-bastion_subnets.ids}"
}
output "public_lb_subnets" {
  value = "${module.public_lb_subnets.ids}"
}

output "private_app_subnets" {
  value = "${module.private_app_subnets.ids}"
}

output "private_db_subnets" {
  value = "${module.private_db_subnets.ids}"
}

output "private_rts" {
  value = ["${aws_route_table.private.*.id}"]
}

output "public_rts" {
  value = ["${aws_route_table.public.*.id}"]
}

output "default_network_acl_id" {
  value = "${aws_vpc.main.default_network_acl_id}"
}
