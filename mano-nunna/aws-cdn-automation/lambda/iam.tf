resource "aws_iam_role" "role_for_lambda_acm" {
  name = var.lambda_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy_for_lambda_acm" {
  name        = var.lambda_policy_name
  description = "IAM policy for Lambda function execution with ACM access"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "acm:RequestCertificate",
        "acm:GetCertificate",
        "acm:GetCertificateValidationRecord",
        "acm:DescribeCertificate"
      ],
      "Resource": "*"
    }
   
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  policy_arn = aws_iam_policy.policy_for_lambda_acm.arn
  role       = aws_iam_role.role_for_lambda_acm.name
}