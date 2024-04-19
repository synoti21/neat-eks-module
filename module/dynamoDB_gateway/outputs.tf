output "vpc_dynamoDB_endpoint_id" {
  value = aws_vpc_endpoint.dynamoDB_gateway_endpoint.id
}