resource "aws_iam_role" "stepfunctions_role" {
  name = var.step_func_role_name
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "states.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "stepfunctions_policy" {
  name        = var.step_func_policy_name
  description = "IAM policy for Step Functions workflow"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "lambda:InvokeFunction",
          "lambda:CreateFunction",
          "lambda:UpdateFunctionCode",
          "lambda:CreateAlias",
          "lambda:GetFunction",
          "ses:SendEmail",
          "ses:SendRawEmail",
          "cloudfront:CreateDistribution",
          "cloudfront:UpdateDistribution",
          "cloudfront:GetDistribution",
          "cloudfront:CreateInvalidation",
          "route53:ChangeResourceRecordSets",
          "route53:GetChange",
          "acm:RequestCertificate",
          "acm:DescribeCertificate",
          "acm:ValidateCertificate",
          "logs:CreateLogDelivery",
          "logs:CreateLogStream",
          "logs:GetLogDelivery",
          "logs:UpdateLogDelivery",
          "logs:DeleteLogDelivery",
          "logs:ListLogDeliveries",
          "logs:PutLogEvents",
          "logs:PutResourcePolicy",
          "logs:DescribeResourcePolicies",
          "logs:DescribeLogGroups",
          "s3:*"
        ],
        Resource = "*",
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "stepfunctions_policy_attach" {
  policy_arn = aws_iam_policy.stepfunctions_policy.arn
  role       = aws_iam_role.stepfunctions_role.name
}
