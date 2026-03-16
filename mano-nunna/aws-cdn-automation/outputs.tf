output "create_acm_lambda_arn" {
  value = module.lambda_acm.create_acm_lambda_arn
}
output "get_crecords_lambda_arn" {
  value = module.lambda_acm.get_crecords_lambda_arn
}
output "describe_acm_lambda_arn" {
  value = module.lambda_acm.describe_acm_lambda_arn
}
output "OAI_ID" {
  value = module.src_bucket.OAI_ID
}

output "bucket_endpoint" {
  value=module.cdn_logs_bucket.bucket_endpoint
}