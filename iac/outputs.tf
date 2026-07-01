output "alb_dns_name" {
  description = "Public DNS name of the load balancer - point your domain's CNAME/ALIAS here"
  value       = aws_lb.main.dns_name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_backend_service_name" {
  value = aws_ecs_service.backend.name
}

output "ecs_frontend_service_name" {
  value = aws_ecs_service.frontend.name
}

output "ecr_backend_repository_url" {
  value = aws_ecr_repository.backend.repository_url
}

output "ecr_frontend_repository_url" {
  value = aws_ecr_repository.frontend.repository_url
}

output "rds_endpoint" {
  description = "Postgres endpoint (host:port)"
  value       = aws_db_instance.main.endpoint
}

output "database_secret_arn" {
  description = "Secrets Manager ARN holding the DB connection string"
  value       = aws_secretsmanager_secret.database_url.arn
}

output "github_actions_role_arn" {
  description = "Put this in your GitHub Actions workflow / use for AWS_ACCOUNT_ID derivation"
  value       = aws_iam_role.github_actions_deploy.arn
}

output "ecs_execution_role_arn" {
  value = aws_iam_role.ecs_execution_role.arn
}

output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}
