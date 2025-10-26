resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_range
  instance_tenancy = var.vpc_tenancy

  tags = var.vpc_tags
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id 
  cidr_block = var.vpc_subnet_cidr_range
  availability_zone = var.vpc_subnet_availability_zone

  tags = var.vpc_subnet_tags

  depends_on = [ aws_vpc.vpc ]
}

resource "aws_security_group" "sg" {
  name        = var.vpc_sg_name
  description = var.vpc_sg_desc
  vpc_id      = aws_vpc.vpc.id 

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.vpc_sg_tags

  depends_on = [ aws_vpc.vpc ]
}