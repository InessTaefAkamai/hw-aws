output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id_a" {
  value = aws_subnet.public_a.id
}

output "public_subnet_id_b" {
  value = aws_subnet.public_b.id
}

output "ecs_security_group" {
  value = aws_security_group.ecs_sg.id
}
