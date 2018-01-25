resource "aws_cloudwatch_metric_alarm" "watch_cpu_high" {
  alarm_name = "fargate-cpu-utilization-above-50"
  alarm_description = "This alarm monitors fargate CPU utilization for scaling up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/ECS"
  period = "120"
  statistic = "Average"
  threshold = "50"
  alarm_actions = ["${aws_appautoscaling_policy.scale_up.arn}"]

  dimensions {
    ClusterName = "ecs_cluster_a"
    ServiceName = "myterraformtestc_svc"
  }
}

resource "aws_appautoscaling_target" "target" {
  service_namespace ="ecs"
  resource_id = "service/ecs_cluster_a/myterraformtestc_svc"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity = 1
  max_capacity = 5
}

resource "aws_appautoscaling_policy" "scale_up" {
  service_namespace ="ecs"
  name = "myterraformtestc_svc-scale-up"
  resource_id = "service/ecs_cluster_a/myterraformtestc_svc"
  scalable_dimension = "ecs:service:DesiredCount"
  adjustment_type = "ChangeInCapacity"
  cooldown = 120
  metric_aggregation_type = "Average"
  step_adjustment {
    metric_interval_lower_bound = 0
    scaling_adjustment = 1
  }
  depends_on = ["aws_appautoscaling_target.target"]
}

resource "aws_appautoscaling_policy" "scale_down" {
  service_namespace ="ecs"
  name = "myterraformtestc_svc-scale-down"
  resource_id = "service/ecs_cluster_a/myterraformtestc_svc"
  scalable_dimension = "ecs:service:DesiredCount"
  adjustment_type = "ChangeInCapacity"
  cooldown = 120
  metric_aggregation_type = "Average"
  step_adjustment {
    metric_interval_upper_bound = 0
    scaling_adjustment = -1
  }
  depends_on = ["aws_appautoscaling_target.target"]
}