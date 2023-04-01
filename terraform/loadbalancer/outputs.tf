output "target_group_arn" {
  value = aws_lb_target_group.wp_tg.arn
}

output "alias_name" {
  value = aws_lb.wp_lb.dns_name
}

output "lb_zone_id" {
  value = aws_lb.wp_lb.zone_id
}

output "wp_lb" {
  value = aws_lb.wp_lb.arn
}