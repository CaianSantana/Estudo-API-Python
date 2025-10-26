output "vpc_id" {
  value = aws_vpc.vpc.id
  sensitive = false
  description = "ID da VPC"
}

output "vpc_main_route_table_id" {
  value = aws_vpc.vpc.main_route_table_id
  sensitive = false
  description = "ID da tabela de roteamento principal da VPC"
}

output "vpc_subnet_id" {
  value = aws_subnet.subnet.id
  sensitive = false
  description = "ID da Sub-rede"
}

output "vpc_sg_id" {
  value = aws_security_group.sg.id
  sensitive = false
  description = "ID do Grupo de Segurança"
}