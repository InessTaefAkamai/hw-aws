output "ecr_repository_url" {
  value = aws_ecr_repository.repo.repository_url
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.tg.arn
}

output "ecs_security_group" {
  value = aws_security_group.ecs_sg.id
}

output "public_subnet_id_a" {
  value = aws_subnet.subnet_a.id
}

output "public_subnet_id_b" {
  value = aws_subnet.subnet_b.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}
