output "ids" {
  value = aws_subnet.subnets.*.id
}

output "azs" {
  value = aws_subnet.subnets.*.availability_zone
}
