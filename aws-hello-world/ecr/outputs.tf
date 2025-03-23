output "ecr_repository_url" {
  description = "The ECR repository URL"
  value       = aws_ecr_repository.repo.repository_url
}
