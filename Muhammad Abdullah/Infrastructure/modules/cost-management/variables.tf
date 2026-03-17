# AWS Budgets
variable "project_info" {
  description = "Project info i.e env, project name etc"
  type        = list(string)
}

variable "budgets" {
  default = [
    {
      name              = "monthly-zero-cost-budget"
      budget_type       = "COST"
      limit_amount      = "1"
      limit_unit        = "USD"
      time_period_start = "2025-04-07_00:00"
      time_period_end   = "2025-04-30_00:00"
      time_unit         = "MONTHLY"

      notification = {
        comparison_operator = "GREATER_THAN"
        threshold           = "10"
        threshold_type      = "PERCENTAGE"
        notification_type   = "FORECASTED"
      }
    }
  ]
  description = "The list of budget."
  type = list(object({
    name              = string
    budget_type       = string
    limit_amount      = string
    limit_unit        = string
    time_period_start = string
    time_period_end   = string
    time_unit         = string

    cost_filter = optional(map(list(string)))

    notification = object({
      comparison_operator = string
      threshold           = string
      threshold_type      = string
      notification_type   = string
    })
  }))
}

variable "name" {
  description = "The name of the budget."
  type        = string
}

variable "recipients" {
  description = "The email addresses to send notifications to."
  type        = list(string)
}