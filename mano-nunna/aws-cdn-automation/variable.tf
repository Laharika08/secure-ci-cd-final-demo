variable "create_acm_function_name" {
  type=string
  default="create-acm-nv"
}

variable "create_acm_handler" {
  type=string
  default = "create-acm-nv.lambda_handler"
}

variable"runtime"{
    type=string
    default = "python3.12"
}
variable "get_crecords_function_name" {
  type=string
  default="get-crecords-nv"
}

variable "get_crecords_handler" {
  type=string
  default = "get-crecords-nv.lambda_handler"
}
variable "describe_acm_function_name" {
  type=string
  default="describe-acm-nv"
}

variable "describe_acm_handler" {
  type=string
  default = "describe-acm-nv.lambda_handler"
}

#variables of lambda func role&policy
variable "lambda_role_name" {
  type=string
  default="role_for_lambda_acm"
}

variable "lambda_policy_name"{
    type=string
    default="policy_for_lambda_acm"
}

#variables of stepfunctions
variable "step_func_name" {
  type=string
  default="coderview_acm_cdn_stepfunctions"
}

variable "step_func_role_name"{
    type=string
    default="StepFunctionsExecutionRole"
}

variable "step_func_policy_name"{
    type= string
    default="StepFunctionsPolicy"
}
variable "definition" {
  default=""
}

variable "step_func_tags"{
    type=map(string)
    default=null
}
variable "cdn_logs_bucket_endpoint"{
  type=string
  default=""
}

variable "sfn_cloudwatch_log_group_name"{
  type=string
  default="stepfunctions_log_group"
}

variable "retention_in_days"{
  type=number
  default=7
}

variable "include_execution_data"{
  type=bool
  default=true
}

variable "level"{
  type=string
  default="ALL"
}

variable "cloudwatch_tags"{
  type=map(string)
  default=null
}
#bucket
variable "bucket_name"{
  type=string
  default="coderview-cdn-logs-s3bucket"
}

variable "bucket_tags"{
  type=map(string)
  default=null
}

variable "account_id"{
  type=number
  default=133521243113
}

variable "create_acm_lambda_arn"{
  type=string
  default=null
}
variable "get_crecords_lambda_arn"{
  type=string
  default=null
}
variable "describe_acm_lambda_arn"{
  type=string
  default=null
}
variable "origin_access_identity"{
  type=string
  default=null
}
#src_bucket
variable "source_code_bucket_name"{
    type= string
    default="coderview-src-cdn-bucket"
}

variable "src_bucket_tags"{
    type= map(string)
    default={
    "Env":"Dev"
    "Project":"Coderview"
  }
}

variable "src_bucket_acl"{
    type=string
    default="private"
}

variable "index_document_suffix"{
    type=string
    default="index.html"
}

variable "error_document_key" {
    type=string
    default="error.html"
}

variable "content_type"{
    type=string
    default="text/html"
}