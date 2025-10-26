module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr_range = "10.10.0.0/16"
  vpc_tenancy    = "default"

  vpc_tags = {
    IaC = true
  }

  vpc_subnet_tags = {
    IaC = true
  }

  vpc_sg_tags = {
    IaC = true
  }
}

resource "aws_ecr_repository" "ecr_repository" {
  name                 = "${var.api_name}-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    IaC = true
  }
}

resource "aws_apprunner_vpc_connector" "app_connector" {
  vpc_connector_name = "${var.api_name}-vpc-connector"
  subnets            = [module.vpc.vpc_subnet_id]
  security_groups    = [module.vpc.vpc_sg_id]

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
      image_identifier      = "${aws_ecr_repository.ecr_repository.repository_url}:latest"
      image_repository_type = "ECR"
    }
    auto_deployments_enabled = true
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_role.arn
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

}