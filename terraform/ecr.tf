resource "aws_ecr_repository" "backend_repo" {
  name = "login-app-backend"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete  = true
}