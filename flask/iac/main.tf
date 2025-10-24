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

# resource "aws_apprunner_service" "apprunner_service" {
#   service_name = "${var.api_name}-apprunner"

#   source_configuration {
#     image_repository {
#       image_configuration {
#         port = var.api_port
#       }
#       image_identifier      = "${aws_ecr_repository.ecr_repository.repository_url}/${var.container_name}:latest"
#       image_repository_type = "ECR"
#     }
#     auto_deployments_enabled = false
#   }

#   tags = {
#     Name = "${var.api_name}-apprunner-service"
#     IaC  = true
#   }

# }