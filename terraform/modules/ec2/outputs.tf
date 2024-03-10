output "asg_arn" {
  value = aws_autoscaling_group.ecs_asg.arn
}

output "lb_target_group" {
  value = aws_lb_target_group.ecs_tg[0].arn
}

output "loadbalancer_dns" {
  value = aws_lb.ecs_alb[0].dns_name
}