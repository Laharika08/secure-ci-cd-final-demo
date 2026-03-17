#lambda_acm

create_acm_function_name="bimo-create-acm-nv"
create_acm_handler = "bimo-create-acm-nv.lambda_handler"
runtime = "python3.12"

get_crecords_function_name="bimo-get-crecords-nv"
get_crecords_handler = "bimo-get-crecords-nv.lambda_handler"

describe_acm_function_name="bimo-describe-acm-nv"
describe_acm_handler = "bimo-describe-acm-nv.lambda_handler"
lambda_role_name="BiMO_role_for_lambda_acm"
lambda_policy_name="BiMo_policy_for_lambda_acm"

#step_functions
step_func_name="BiMo_acm_cdn_stepfunctions"
step_func_role_name="BiMo_StepFunctionsExecutionRole"
step_func_policy_name="BiMo_StepFunctionsPolicy"
step_func_tags={
        "Env"="Dev",
        "Project"="BiMo"
    }  
sfn_cloudwatch_log_group_name= "BiMo_stepfunctions_log_group"
retention_in_days = 7
include_execution_data = true
level                  = "ALL"
cloudwatch_tags = {
  "Env"="Dev",
  "Project"="BiMo"
}
#cdn_logs_bucket
bucket_name = "bimo-cdn-logs"
bucket_tags = {
    Name        = "bimo-cdn-logs"
    Environment = "Dev"
    Project="BiMo"
  }
account_id = 133521243113
#src_bucket
source_code_bucket_name="bimo-src-cdn"
src_bucket_tags={
    "Env":"Dev"
    "Project":"BiMo"
  }
src_bucket_acl="private"
index_document_suffix="index.html"
error_document_key="error.html"
content_type="text/html"