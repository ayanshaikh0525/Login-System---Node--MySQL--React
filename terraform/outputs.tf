output "alb_dns" {
  value = aws_lb.app_lb.dns_name
}

output "ecr_repo_url" {
  value = aws_ecr_repository.backend_repo.repository_url
}


output "frontend_url" {
  value = aws_s3_bucket_website_configuration.frontend_website.website_endpoint
}