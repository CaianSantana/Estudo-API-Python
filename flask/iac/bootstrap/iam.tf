resource "aws_iam_openid_connect_provider" "oidc-git" {
  url = "https://${var.oidc_provider}"
  client_id_list = [
    var.oidc_client,
  ]
  tags = {
    IaC = true
  }
}

resource "aws_iam_role" "github_actions_role" {
  name = "github-actions-pipeline-role"

  assume_role_policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
	{
  	"Effect": "Allow",
  	"Principal": {
    	"Federated": "arn:aws:iam::009160076203:oidc-provider/token.actions.githubusercontent.com"
  	},
  	"Action": "sts:AssumeRoleWithWebIdentity",
  	"Condition": {
    	"StringEquals": {
      	"token.actions.githubusercontent.com:sub": "repo:CaianSantana/Estudo-API-Python:ref:refs/heads/main"
    	}
  	}
	}
  ]
    # "Version" : "2012-10-17",
    # "Statement" : [
    #   {
    #     "Effect" : "Allow",
    #     "Action" : "sts:AssumeRoleWithWebIdentity",
    #     "Principal" : {
    #       "Federated" : "arn:aws:iam::009160076203:oidc-provider/${var.oidc_provider}"
    #     },
    #     "Condition" : {
    #       "StringEquals" : {
    #         "${var.oidc_provider}:aud" : var.oidc_client
    #       },
    #       "StringLike" : {
    #         "${var.oidc_provider}:sub" : "repo:CaianSantana/Estudo-API-Python:*"
    #       }
    #     }
    #   }
    # ]
  })

  tags = {
    IaC = true
  }
}

resource "aws_iam_role_policy" "github_actions_permissions" {
  name = "github-actions-pipeline-permissions"
  role = aws_iam_role.github_actions_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ECRPermissions"
        Action   = "ecr:*"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid      = "S3Permissions"
        Action   = "s3:*"
        Effect   = "Allow"
        Resource = "*" 
      },
      {
        Sid      = "FullAccessToServices"
        Action = [
          "iam:*",
          "rds:*",
          "apprunner:*",
          "ec2:*" 
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "apprunner_role" {
  name = "apprunner_service_role" 

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "build.apprunner.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    IaC = true
  }
}

resource "aws_iam_role_policy_attachment" "apprunner_ecr_policy" {
  role       = aws_iam_role.apprunner_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}