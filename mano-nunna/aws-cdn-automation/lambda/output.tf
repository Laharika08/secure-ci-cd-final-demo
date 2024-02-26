output "create_acm_lambda_arn" {
  value = aws_lambda_function.create_acm_nv.arn
}
output "get_crecords_lambda_arn" {
  value = aws_lambda_function.get_crecords_nv.arn
}
output "describe_acm_lambda_arn" {
  value = aws_lambda_function.describe_acm_nv.arn
}