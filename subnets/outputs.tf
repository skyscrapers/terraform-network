output "ids" {
  value = aws_subnet.subnets.*.id
}
