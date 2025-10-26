resource "aws_iam_openid_connect_provider" "oidc-git" {
  url = "https://${var.oidc_provider}"

  client_id_list = [
    var.oidc_client,
  ]

  thumbprint_list = [var.thumbprint]

  tags = {
    IaC = true
  }
}

resource "aws_iam_role" "ecr_role" {
  name = "ecr_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Principal" : {
          "Federated" : "arn:aws:iam::009160076203:oidc-provider/${var.oidc_provider}"
        },
        "Condition" : {
          "StringEquals" : {
            "${var.oidc_provider}:aud" : [
              "${var.oidc_client}"
            ]
          },
          "StringLike" : {
            "${var.oidc_provider}:sub" : [
              "repo:caiansantana/Estudo-API-Python:ref:refs/heads/main",
              "repo:caiansantana/Estudo-API-Python:ref:refs/heads/main"
            ]
          }
        }
      }
    ]
  })

  tags = {
    IaC = true
  }
}

resource "aws_iam_role_policy" "ecr_app_permission" {
  name = "github-ecr-push-permission"
  role = aws_iam_role.ecr_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "AllowECRAuth",
        "Effect" : "Allow",
        "Action" : "ecr:GetAuthorizationToken",
        "Resource" : "*"
      },
      {
        "Sid" : "AllowECRPush",
        "Effect" : "Allow",
        "Action" : [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ],
        "Resource" : "*"
      }
    ]
  })
}
resource "aws_iam_role" "apprunner_role" {
  name = "apprunner_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Federated" : "tasks.apprunner.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    IaC = true
  }
}

resource "aws_iam_role_policy_attachment" "ec2ro-attach" {
  role       = aws_iam_role.apprunner_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}




