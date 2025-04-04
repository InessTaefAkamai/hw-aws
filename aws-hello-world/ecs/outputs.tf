output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.alb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.tg.arn
}



