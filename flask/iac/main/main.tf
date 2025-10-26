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
  type                     = "egress" # 
  security_group_id        = aws_security_group.app_sg.id 
  
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  
  source_security_group_id = aws_security_group.db_sg.id 
}

resource "aws_security_group_rule" "db_from_app" {
  type                     = "ingress" 
  security_group_id        = aws_security_group.db_sg.id 
  
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  
  source_security_group_id = aws_security_group.app_sg.id
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "db_subnet_group"
  subnet_ids = module.vpc.subnet_ids

  tags = {
    IaC = true
  }
}

resource "aws_db_instance" "db" {
  allocated_storage      = 20
  db_name                = var.db_name
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t4g.micro"
  username               = var.db_user
  password               = var.db_pass
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  tags = {
    IaC = true
  }
}

resource "aws_apprunner_vpc_connector" "app_connector" {
  vpc_connector_name = "${var.api_name}-vpc-connector"
  subnets = module.vpc.subnet_ids
  security_groups = [aws_security_group.app_sg.id]

  tags = {
    IaC = true
  }
}

resource "aws_apprunner_service" "apprunner_service" {
  service_name = "${var.api_name}-apprunner"

  source_configuration {
    image_repository {
      image_configuration {
        port = var.api_port
      }
      image_identifier      = "${var.ecr_url}:${var.app_image_tag}"
      image_repository_type = "ECR"
    }
    auto_deployments_enabled = true
    authentication_configuration {
      access_role_arn = data.aws_iam_role.apprunner_role.arn
    }
  }

  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.app_connector.arn
    }
  }

  tags = {
    Name = "${var.api_name}-apprunner-service"
    IaC  = true
  }

  depends_on = [aws_apprunner_vpc_connector.app_connector, aws_db_instance.db]
}