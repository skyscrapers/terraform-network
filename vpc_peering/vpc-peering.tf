resource "aws_vpc_peering_connection" "peering" {
  provider      = aws.source
  peer_owner_id = var.target_account_id
  peer_vpc_id   = var.target_vpc_id
  vpc_id        = var.source_vpc_id
  auto_accept   = false

  tags = merge(var.tags, {
    Name = "VPC Peering between ${var.source_name} and ${var.target_name} VPCs"
  })
}

resource "aws_vpc_peering_connection_accepter" "peering" {
  provider                  = aws.target
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  auto_accept               = true

  tags = merge(var.tags, {
    Name = "VPC Peering between ${var.source_name} and ${var.target_name} VPCs"
  })
}

resource "aws_vpc_peering_connection_options" "peering_requester" {
  provider                  = aws.source
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peering.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection_options" "peering_accepter" {
  provider                  = aws.target
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peering.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}
