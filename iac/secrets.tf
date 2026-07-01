# Stored as a plain connection string (not JSON) so it can be referenced
# directly via `valueFrom` in the ECS task definition's `secrets` block,
# matching ecs/backend-task-def.json in the app repo.

resource "aws_secretsmanager_secret" "database_url" {
  name        = "${var.project_name}/database-url"
  description = "Postgres connection string for the ${var.project_name} backend"
}

resource "aws_secretsmanager_secret_version" "database_url" {
  secret_id = aws_secretsmanager_secret.database_url.id
  secret_string = "postgresql://${var.db_username}:${random_password.db.result}@${aws_db_instance.main.endpoint}/${var.db_name}"
}
