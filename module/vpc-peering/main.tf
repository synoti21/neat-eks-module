data "aws_vpc" "peering_accepter_vpc" {
  filter {
    name = "tag:Name"
    values = ["accepter-vpc"]
  }
}

resource "aws_vpc_peering_connection" "vpc_peering" {
  peer_vpc_id   = data.aws_vpc.peering_accepter_vpc.id #accepter
  vpc_id        = var.requester_vpc_id #requester
  auto_accept = true

  tags = {
    Name = "accepter-${var.requester_name}-pc-1"
  }

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}