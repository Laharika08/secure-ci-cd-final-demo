data "template_file" "step_func_data" {
  template = file("${path.module}/templates/step_func.tpl")
  vars = {
    create_acm_lambda_arn     = var.create_acm_lambda_arn
    get_crecords_lambda_arn     = var.get_crecords_lambda_arn
    describe_acm_lambda_arn = var.describe_acm_lambda_arn
    origin_access_identity=var.origin_access_identity
    cdn_logs_bucket_endpoint= var.cdn_logs_bucket_endpoint
  }
}