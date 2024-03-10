output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnets" {
  description = "List of available subnets"
  value       = aws_subnet.subnet
}

output "sg_allow_http_id" {
  description = "Security Group to allow HTTP traffic"
  value       = aws_security_group.allow_http.id
}

output "sg_default_id" {
  value = aws_vpc.main.default_security_group_id
}

