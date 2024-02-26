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