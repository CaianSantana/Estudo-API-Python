resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr_range
  instance_tenancy = var.vpc_tenancy
  tags             = var.vpc_tags
}

resource "aws_subnet" "subnet" {
  count = length(var.vpc_subnet_cidr_range)

  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.vpc_subnet_cidr_range[count.index]
  
  availability_zone = var.vpc_subnet_availability_zones[count.index]

  tags = var.vpc_subnet_tags
}