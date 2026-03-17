#generating acm certificate
data "archive_file" "create_acm_nv" {
  type        = "zip"
  source_file = "${path.module}/bimo-create-acm-nv.py"
  output_path = "${path.module}/bimo-create-acm-nv.zip"
}

resource "aws_lambda_function" "create_acm_nv" {
  function_name    = var.create_acm_function_name
  handler          = var.create_acm_handler
  runtime          = var.runtime
  role             = aws_iam_role.role_for_lambda_acm.arn
  filename         = data.archive_file.create_acm_nv.output_path
  source_code_hash = filebase64sha256(data.archive_file.create_acm_nv.output_path)
}

#getting crecords of acm certificates
data "archive_file" "get_crecords_nv" {
  type        = "zip"
  source_file = "${path.module}/bimo-get-crecords-nv.py"
  output_path = "${path.module}/bimo-get-crecords-nv.zip"
}

resource "aws_lambda_function" "get_crecords_nv" {
  function_name    = var.get_crecords_function_name
  handler          = var.get_crecords_handler
  runtime          = var.runtime
  role             = aws_iam_role.role_for_lambda_acm.arn
  filename         = data.archive_file.get_crecords_nv.output_path
  source_code_hash = filebase64sha256(data.archive_file.get_crecords_nv.output_path)
}

#describing acm certificate
data "archive_file" "describe_acm_nv" {
  type        = "zip"
  source_file = "${path.module}/bimo-describe-acm-nv.py"
  output_path = "${path.module}/bimo-describe-acm-nv.zip"
}

resource "aws_lambda_function" "describe_acm_nv" {
  function_name    = var.describe_acm_function_name
  handler          = var.describe_acm_handler
  runtime          = var.runtime
  role             = aws_iam_role.role_for_lambda_acm.arn
  filename         = data.archive_file.describe_acm_nv.output_path
  source_code_hash = filebase64sha256(data.archive_file.describe_acm_nv.output_path)
}