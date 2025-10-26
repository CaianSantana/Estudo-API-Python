module "vpc" {
  source                = "./modules/vpc"
  vpc_cidr_range        = "10.10.0.0/16"
  vpc_subnet_cidr_range = ["10.10.1.0/24", "10.10.2.0/24"]

  vpc_subnet_availability_zones = [
    data.aws_availability_zones.available.names[0],
    data.aws_availability_zones.available.names[1]
  ]

  vpc_tags = {
    IaC = true
  }

  vpc_subnet_tags = {
    IaC = true
  }
}

resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "SG para o AppRunner"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-sg"
    IaC  = true
  }
}

resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "SG para o RDS"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "db-sg"
    IaC  = true
  }
}

resource "aws_security_group_rule" "app_to_db" {
  type              = "egress" # 
  security_group_id = aws_security_group.app_sg.id

  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"

  source_security_group_id = aws_security_group.db_sg.id
}

resource "aws_security_group_rule" "db_from_app" {
  type              = "ingress"
  security_group_id = aws_security_group.db_sg.id

  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"

  source_security_group_id = aws_security_group.app_sg.id
}