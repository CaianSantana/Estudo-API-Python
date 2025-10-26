variable "vpc_cidr_range" {
  description = "Bloco CIDR para a VPC"
  type        = string
}

variable "vpc_tenancy" {
  description = "Tenancy da VPC"
  type        = string
  default     = "default"
}

variable "vpc_subnet_cidr_range" {
  description = "Lista de blocos CIDR para as subnets"
  type        = list(string)
}

variable "vpc_subnet_availability_zones" {
  description = "Lista de Zonas de Disponibilidade para as subnets"
  type        = list(string)
}

variable "vpc_tags" {
  description = "Tags para a VPC"
  type        = map(string)
  default     = {}
}

variable "vpc_subnet_tags" {
  description = "Tags para as Subnets"
  type        = map(string)
  default     = {}
}