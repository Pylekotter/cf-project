# --- cloudwatch/main.tf

resource "aws_cloudwatch_metric_alarm" "alb_healthyhosts" {
  alarm_name          = "Web_Application_Alive"
  comparison_operator = "LessThanThreshold"
  namespace           = "AWS/NetworkELB"
  evaluation_periods  = 1
  metric_name         = "HealthyHostCount"
  period              = 60
  statistic           = "Average"
  alarm_description   = "Number of healthy nodes in Target Group"
  actions_enabled     = "true"
  #   alarm_actions       = [aws_sns_topic.sns.arn]
  #   ok_actions          = [aws_sns_topic.sns.arn]
  dimensions = {
    TargetGroup  = var.cw_target_group
    LoadBalancer = var.cw_loadbalancer
  }
}