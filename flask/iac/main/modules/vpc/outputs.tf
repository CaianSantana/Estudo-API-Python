output "vpc_id" {
  description = "O ID da VPC criada"
  value       = aws_vpc.vpc.id
}

output "subnet_ids" {
  description = "A lista de IDs das subnets criadas"
  value       = aws_subnet.subnet.*.id
}