resource "aws_iam_role" "terraform-codepipeline-role" {
  name = "terraform-codepipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

data "aws_iam_policy_document" "terraform-cicd-pipeline-policies" {
    statement{
        sid = ""
        actions = ["codestar-connections:UseConnection"]
        resources = ["*"]
        effect = "Allow"
    }
    statement{
        sid = ""
        actions = ["cloudwatch:*", "s3:*", "codebuild:*"]
        resources = ["*"]
        effect = "Allow"
    }
     statement{
        sid = ""
        actions = ["cloudwatch:*", "s3:*", "codedeploy:*"]
        resources = ["*"]
        effect = "Allow"
    }
}


resource "aws_iam_policy" "terraform-cicd-pipeline-policy" {
    name = "terraform-cicd-pipeline-policy"
    path = "/"
    description = "Pipeline policy"
    policy = data.aws_iam_policy_document.terraform-cicd-pipeline-policies.json
}

resource "aws_iam_role_policy_attachment" "tf-cicd-pipeline-attachment" {
    policy_arn = aws_iam_policy.terraform-cicd-pipeline-policy.arn
    role = aws_iam_role.terraform-codepipeline-role.id
}


resource "aws_iam_role" "terraform-codebuild-role" {
  name = "terraform-codebuild-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

data "aws_iam_policy_document" "terraform-cicd-build-policies" {
    statement{
        sid = ""
        actions = ["logs:*", "s3:*", "codebuild:*", "secretsmanager:*","iam:*"]
        resources = ["*"]
        effect = "Allow"
    }
}

resource "aws_iam_policy" "terraform-cicd-build-policy" {
    name = "terraform-cicd-build-policy"
    path = "/"
    description = "Codebuild policy"
    policy = data.aws_iam_policy_document.terraform-cicd-build-policies.json
}

resource "aws_iam_role_policy_attachment" "terraform-cicd-codebuild-attachment1" {
    policy_arn  = aws_iam_policy.terraform-cicd-build-policy.arn
    role        = aws_iam_role.terraform-codebuild-role.id
}

resource "aws_iam_role_policy_attachment" "terraform-cicd-codebuild-attachment2" {
    policy_arn  = "arn:aws:iam::aws:policy/PowerUserAccess"
    role        = aws_iam_role.terraform-codebuild-role.id
}
resource "aws_iam_role" "terraform-codedeploy-role" {
  name = "terraform-codedeploy-role"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "Service": "codedeploy.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
EOF
}



resource "aws_iam_role_policy_attachment" "codedeploy_policy_attachment" {
  role       = aws_iam_role.terraform-codedeploy-role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}







