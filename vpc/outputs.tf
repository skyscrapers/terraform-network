output "vpc_id" {
  description = "The id of the vpc created"
  value       = aws_vpc.main.id
}

output "public_nat-bastion" {
  description = "List of the public_nat-bastion subnets id created"
  value       = module.public_nat-bastion_subnets.ids
}

output "public_lb_subnets" {
  description = "List of the public_lb subnets id created"
  value       = module.public_lb_subnets.ids
}

output "private_app_subnets" {
  description = "List of the private_app subnets id created"
  value       = module.private_app_subnets.ids
}

output "private_db_subnets" {
  description = "List of the private_db subnets id created"
  value       = module.private_db_subnets.ids
}

output "private_management_subnets" {
  description = "List of the private_management subnets id created"
  value       = module.private_management_subnets.ids
}

output "private_rts" {
  description = "List of the ids of the private route tables created"
  value       = aws_route_table.private.*.id
}

output "public_rts" {
  description = "List of the ids of the public route tables created"
  value       = aws_route_table.public.*.id
}

output "default_network_acl_id" {
  description = "Id of the default network acl"
  value       = aws_vpc.main.default_network_acl_id
}
