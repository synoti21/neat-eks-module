output "vpc_s3_endpoint_id" {
  value = aws_vpc_endpoint.s3_gateway_endpoint.id
}
