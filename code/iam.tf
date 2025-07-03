resource "aws_iam_policy" "full_access_policy" {
  name        = "SecretsSqsEcrFullAccess"
  description = "Full access to Secrets Manager, SQS, and ECR"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "secretsmanager:*",
          "sqs:*",
          "ecr:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "app_role" {
  name = "app-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy_to_role" {
  role       = aws_iam_role.app_role.name
  policy_arn = aws_iam_policy.full_access_policy.arn
}


resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

