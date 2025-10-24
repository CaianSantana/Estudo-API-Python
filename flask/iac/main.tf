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