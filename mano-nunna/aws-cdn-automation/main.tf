module "lambda_acm"{
    source="./lambda"
    create_acm_function_name=var.create_acm_function_name
    create_acm_handler = var.create_acm_handler
    runtime = var.runtime
    get_crecords_function_name=var.get_crecords_function_name
    get_crecords_handler = var.get_crecords_handler
    describe_acm_function_name=var.describe_acm_function_name
    describe_acm_handler = var.describe_acm_handler
    lambda_role_name=var.lambda_role_name
    lambda_policy_name=var.lambda_policy_name
}

module "step_functions"{
    source="./stepfunctions"
    depends_on = [ module.lambda_acm,module.cdn_logs_bucket,module.src_bucket ]
    step_func_name=var.step_func_name
    step_func_role_name=var.step_func_role_name
    step_func_policy_name=var.step_func_policy_name
    step_func_tags=var.step_func_tags  
    sfn_cloudwatch_log_group_name= var.sfn_cloudwatch_log_group_name
    retention_in_days = var.retention_in_days
    include_execution_data = var.include_execution_data
    level                  = var.level
    cloudwatch_tags = var.cloudwatch_tags
    create_acm_lambda_arn     = module.lambda_acm.create_acm_lambda_arn
    get_crecords_lambda_arn     = module.lambda_acm.get_crecords_lambda_arn
    describe_acm_lambda_arn = module.lambda_acm.describe_acm_lambda_arn
    origin_access_identity=module.src_bucket.OAI_ID
    cdn_logs_bucket_endpoint=module.cdn_logs_bucket.bucket_endpoint
}

module "cdn_logs_bucket"{
    source="./cdnlogs_bucket"
    bucket_name = var.bucket_name
    bucket_tags =var.bucket_tags
    account_id = var.account_id
}

module "src_bucket"{
    source="./source_code_bucket"
    source_code_bucket_name=var.source_code_bucket_name
    src_bucket_tags=var.src_bucket_tags
    src_bucket_acl=var.src_bucket_acl
    index_document_suffix=var.index_document_suffix
    error_document_key=var.error_document_key
    content_type=var.content_type
}