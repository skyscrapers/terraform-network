output "ids" {
  value = ["${aws_nat_gateway.gateway.*.id}"]
}
