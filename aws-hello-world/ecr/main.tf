resource "aws_ecr_repository" "repo" {
  name = var.ecr_repo_name
  force_delete = true
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = var.ecr_repo_name
  }
}
