variable "vpc_cidr_range" {
  description = "Range da VPC"
  type = string
  default = "10.10.0.0/16"
}

variable "vpc_tenancy" {
  description = "Locatário da rede"
  type = string
  default = "default"
}

variable "vpc_tags" {
  description = "Tags da VPC"
  type = map(string)
  default = {}
}

variable "vpc_subnet_cidr_range" {
  description = "Range da Sub-rede"
  type = string
  default = "10.10.1.0/24"
}

variable "vpc_subnet_availability_zone" {
  description = "Zona de disponibilidade da Sub-rede"
  type = string
  default = "us-west-2a"
}

variable "vpc_subnet_tags" {
  description = "Tags da Sub-rede"
  type = map(string)
  default = {}
}

variable "vpc_sg_name" {
  description = "Nome do Grupo de Segurança"
  type = string
  default = "allow-ssh"
}

variable "vpc_sg_desc" {
  description = "Descrição do Grupo de Segurança"
  type = string
  default = "Permite SSH"
}

variable "vpc_sg_tags" {
  description = "Tags do Grupo de Segurança"
  type = map(string)
  default = {}
}