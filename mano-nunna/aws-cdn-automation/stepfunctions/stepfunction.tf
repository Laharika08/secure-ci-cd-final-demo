resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = var.step_func_name
  role_arn = aws_iam_role.stepfunctions_role.arn
  definition = data.template_file.step_func_data.rendered
  tags=var.step_func_tags
  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.log_group_for_sfn.arn}:*"
    include_execution_data = var.include_execution_data
    level                  = var.level
  }
}

resource "aws_cloudwatch_log_group" "log_group_for_sfn" {
  name              = var.sfn_cloudwatch_log_group_name
  retention_in_days = var.retention_in_days
  tags=var.cloudwatch_tags
}