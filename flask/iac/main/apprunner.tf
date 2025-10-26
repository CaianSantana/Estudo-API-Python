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