resource "aws_route" "source_to_target" {
  provider = aws.source
  for_each = toset(var.source_route_table_ids)

  route_table_id            = each.value
  destination_cidr_block    = data.aws_vpc.target.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peering.id
}

resource "aws_route" "target_to_source" {
  provider = aws.target
  for_each = toset(var.target_route_table_ids)

  route_table_id            = each.value
  destination_cidr_block    = data.aws_vpc.source.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peering.id
}
