output "ids" {
  value = aws_nat_gateway.gateway.*.id
}

output "ips" {
  value = aws_eip.nat_gateway.*.public_ip
}
