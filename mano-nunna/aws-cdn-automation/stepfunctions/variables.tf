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
  default="origin-access-identity/cloudfront/test"
}

variable "cdn_logs_bucket_endpoint"{
  type=string
  default=null
}