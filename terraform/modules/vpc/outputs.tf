output "vpc_id" {
 description = "The ID of the VPC"
 value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value = aws_subnet.public_subnet[*].id
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value = aws_subnet.private_subnet[*].id
}

output "alb_subnet_public" {
  value = aws_subnet.public_subnet[*].id
}
