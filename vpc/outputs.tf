output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "public_subnets" {
  value = "${module.public_subnets.ids}"
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
