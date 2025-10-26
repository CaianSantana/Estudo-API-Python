data "aws_iam_role" "apprunner_role" {
  name = "apprunner_role"
}

data "aws_availability_zones" "available" {
  state = "available"
}
