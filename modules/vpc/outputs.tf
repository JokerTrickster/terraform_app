output "vpc_id" {
  description = "기본 VPC ID"
  value       = aws_default_vpc.default.id
}

output "vpc_cidr_block" {
  description = "기본 VPC CIDR 블록"
  value       = aws_default_vpc.default.cidr_block
}

output "subnet_ids" {
  description = "기본 VPC의 서브넷 ID 목록"
  value = [
    aws_default_subnet.default_az_a.id,
    aws_default_subnet.default_az_b.id,
    aws_default_subnet.default_az_c.id
  ]
}

output "internet_gateway_id" {
  description = "기본 VPC의 인터넷 게이트웨이 ID"
  value       = data.aws_internet_gateway.default.id
}

output "route_table_id" {
  description = "기본 VPC의 라우팅 테이블 ID"
  value       = data.aws_route_table.default.id
} 