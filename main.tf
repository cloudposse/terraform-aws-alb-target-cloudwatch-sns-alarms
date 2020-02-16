module "default_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  enabled    = var.enabled
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  attributes = var.attributes
  delimiter  = var.delimiter
  tags       = var.tags
}

module "httpcode_target_3xx_alarm_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  enabled    = var.enabled
  context    = module.default_label.context
  attributes = compact(concat(var.attributes, ["3XX", "count", "high"]))
}

module "httpcode_target_4xx_alarm_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  enabled    = var.enabled
  context    = module.default_label.context
  attributes = compact(concat(var.attributes, ["4XX", "count", "high"]))
}

module "httpcode_target_5xx_alarm_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  enabled    = var.enabled
  context    = module.default_label.context
  attributes = compact(concat(var.attributes, ["5XX", "count", "high"]))
}

module "httpcode_elb_5xx_alarm_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  enabled    = var.enabled
  context    = module.default_label.context
  attributes = compact(concat(var.attributes, ["ELB", "5XX", "count", "high"]))
}

module "target_response_time_alarm_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  enabled    = var.enabled
  context    = module.default_label.context
  attributes = compact(concat(var.attributes, ["target", "response", "high"]))
}

locals {
  # default to using notify_arns unless a more specific action is specified.
  alarm_actions             = compact(coalescelist(var.alarm_actions, var.notify_arns))
  ok_actions                = compact(coalescelist(var.ok_actions, var.notify_arns))
  insufficient_data_actions = compact(coalescelist(var.insufficient_data_actions, var.notify_arns))

  thresholds = {
    target_3xx_count     = max(var.target_3xx_count_threshold, 0)
    target_4xx_count     = max(var.target_4xx_count_threshold, 0)
    target_5xx_count     = max(var.target_5xx_count_threshold, 0)
    elb_5xx_count        = max(var.elb_5xx_count_threshold, 0)
    target_response_time = max(var.target_response_time_threshold, 0)
  }

  target_3xx_alarm_enabled           = var.enabled && var.target_3xx_count_threshold > 0
  target_4xx_alarm_enabled           = var.enabled && var.target_4xx_count_threshold > 0
  target_5xx_alarm_enabled           = var.enabled && var.target_5xx_count_threshold > 0
  elb_5xx_alarm_enabled              = var.enabled && var.elb_5xx_count_threshold > 0
  target_response_time_alarm_enabled = var.enabled && var.target_response_time_threshold > 0

  target_group_dimensions_map = {
    "TargetGroup"  = var.target_group_arn_suffix
    "LoadBalancer" = var.alb_arn_suffix
  }

  load_balancer_dimensions_map = {
    "LoadBalancer" = var.alb_arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "httpcode_target_3xx_count" {
  count                     = local.target_3xx_alarm_enabled ? 1 : 0
  alarm_name                = module.httpcode_target_3xx_alarm_label.id
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = var.evaluation_periods
  metric_name               = "HTTPCode_Target_3XX_Count"
  namespace                 = "AWS/ApplicationELB"
  period                    = var.period
  statistic                 = "Sum"
  threshold                 = local.thresholds["target_3xx_count"]
  treat_missing_data        = var.treat_missing_data
  alarm_description         = format(var.httpcode_alarm_description, "3XX", module.default_label.id, local.thresholds["target_3xx_count"], var.period / 60, var.evaluation_periods)
  alarm_actions             = local.alarm_actions
  ok_actions                = local.ok_actions
  insufficient_data_actions = local.insufficient_data_actions
  dimensions                = local.target_group_dimensions_map
  tags                      = module.httpcode_target_3xx_alarm_label.tags
}

resource "aws_cloudwatch_metric_alarm" "httpcode_target_4xx_count" {
  count                     = local.target_4xx_alarm_enabled ? 1 : 0
  alarm_name                = module.httpcode_target_4xx_alarm_label.id
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = var.evaluation_periods
  metric_name               = "HTTPCode_Target_4XX_Count"
  namespace                 = "AWS/ApplicationELB"
  period                    = var.period
  statistic                 = "Sum"
  threshold                 = local.thresholds["target_4xx_count"]
  treat_missing_data        = var.treat_missing_data
  alarm_description         = format(var.httpcode_alarm_description, "4XX", module.default_label.id, local.thresholds["target_4xx_count"], var.period / 60, var.evaluation_periods)
  alarm_actions             = local.alarm_actions
  ok_actions                = local.ok_actions
  insufficient_data_actions = local.insufficient_data_actions
  dimensions                = local.target_group_dimensions_map
  tags                      = module.httpcode_target_4xx_alarm_label.tags
}

resource "aws_cloudwatch_metric_alarm" "httpcode_target_5xx_count" {
  count                     = local.target_5xx_alarm_enabled ? 1 : 0
  alarm_name                = module.httpcode_target_5xx_alarm_label.id
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = var.evaluation_periods
  metric_name               = "HTTPCode_Target_5XX_Count"
  namespace                 = "AWS/ApplicationELB"
  period                    = var.period
  statistic                 = "Sum"
  threshold                 = local.thresholds["target_5xx_count"]
  treat_missing_data        = var.treat_missing_data
  alarm_description         = format(var.httpcode_alarm_description, "5XX", module.default_label.id, local.thresholds["target_5xx_count"], var.period / 60, var.evaluation_periods)
  alarm_actions             = local.alarm_actions
  ok_actions                = local.ok_actions
  insufficient_data_actions = local.insufficient_data_actions
  dimensions                = local.target_group_dimensions_map
  tags                      = module.httpcode_target_5xx_alarm_label.tags
}

resource "aws_cloudwatch_metric_alarm" "httpcode_elb_5xx_count" {
  count                     = local.elb_5xx_alarm_enabled ? 1 : 0
  alarm_name                = module.httpcode_elb_5xx_alarm_label.id
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = var.evaluation_periods
  metric_name               = "HTTPCode_ELB_5XX_Count"
  namespace                 = "AWS/ApplicationELB"
  period                    = var.period
  statistic                 = "Sum"
  threshold                 = local.thresholds["elb_5xx_count"]
  treat_missing_data        = var.treat_missing_data
  alarm_description         = format(var.httpcode_alarm_description, "ELB-5XX", module.default_label.id, local.thresholds["elb_5xx_count"], var.period / 60, var.evaluation_periods)
  alarm_actions             = local.alarm_actions
  ok_actions                = local.ok_actions
  insufficient_data_actions = local.insufficient_data_actions
  dimensions                = local.load_balancer_dimensions_map
  tags                      = module.httpcode_elb_5xx_alarm_label.tags
}

resource "aws_cloudwatch_metric_alarm" "target_response_time_average" {
  count                     = local.target_response_time_alarm_enabled ? 1 : 0
  alarm_name                = format(module.target_response_time_alarm_label.id)
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = var.evaluation_periods
  metric_name               = "TargetResponseTime"
  namespace                 = "AWS/ApplicationELB"
  period                    = var.period
  statistic                 = "Average"
  threshold                 = local.thresholds["target_response_time"]
  treat_missing_data        = var.treat_missing_data
  alarm_description         = format(var.target_response_time_alarm_description, module.default_label.id, local.thresholds["target_response_time"], var.period / 60, var.evaluation_periods)
  alarm_actions             = local.alarm_actions
  ok_actions                = local.ok_actions
  insufficient_data_actions = local.insufficient_data_actions
  dimensions                = local.target_group_dimensions_map
  tags                      = module.target_response_time_alarm_label.tags
}
