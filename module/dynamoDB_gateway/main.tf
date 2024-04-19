data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = ["${var.vpc_name}-vpc"]
  }
}

data "aws_route_table" "selected" {
  vpc_id = data.aws_vpc.selected.id
  filter {
      name = "tag:Name"
      values = ["${var.vpc_name}-vpc-private"]
  }
}

resource "aws_vpc_endpoint" "dynamoDB_gateway_endpoint" {
  vpc_id = data.aws_vpc.selected.id
  service_name = "com.amazonaws.ap-northeast-2.dynamodb"
  route_table_ids = [ data.aws_route_table.selected.id ]

  tags = {
    Name = "dynamoDB-${var.vpc_name}-endpoint"
  }
}
