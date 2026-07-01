# Todo App — GitHub Actions → Amazon ECS

Pipeline: test → build Docker images → push to ECR → deploy to ECS Fargate (backend + frontend as separate services behind an ALB, Postgres on RDS).

## Repo layout expected
```
backend/            # Python (FastAPI) app, requirements.txt, Dockerfile
frontend/            # React app, package.json, Dockerfile, nginx.conf
ecs/                  # ECS task definition templates
.github/workflows/deploy.yml
```

Your `backend/main.py` should expose a `/health` route returning 200, and a FastAPI `app` object.

## One-time AWS setup — via Terraform

All of this (VPC, ALB, ECR, ECS cluster/services, RDS, IAM roles, GitHub OIDC provider, Secrets Manager, CloudWatch log groups) is provisioned by the config in `terraform/`. See `terraform/README.md` for full instructions; short version:

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars: set github_org / github_repo at minimum

terraform init
terraform plan
terraform apply
```

After `apply`, read the outputs for what to put in GitHub secrets:

```bash
terraform output alb_dns_name              # point your domain here, or hit it directly to test
terraform output github_actions_role_arn   # arn:aws:iam::<account>:role/github-actions-ecs-deploy
```

The `AWS_ACCOUNT_ID` GitHub secret referenced by `deploy.yml` is just the account ID portion of that role ARN.

Terraform creates the ECS services with a placeholder ("hello-world"/"nginx") image on the very first apply, since a task definition needs *some* image to exist. From then on, `deploy.yml` registers real task definition revisions and updates the services directly — `terraform apply` won't fight with CI over which revision is live (the service and task definition resources use `lifecycle { ignore_changes = [...] }` for exactly this reason).

## GitHub setup

- **Secrets** (Settings → Secrets and variables → Actions):
  - `AWS_ACCOUNT_ID`
  - `REACT_APP_API_URL` (e.g. `https://api.yourdomain.com`)
- **Environment**: create a `production` environment if you want manual approval gates before deploy.
- Replace `<AWS_ACCOUNT_ID>` and `<AWS_REGION>` placeholders in the two files under `ecs/` with real values from `terraform output`. Role names (`todo-ecs-execution-role`, `todo-ecs-task-role`), the secret name (`todo/database-url`), and log group names (`/ecs/todo-backend`, `/ecs/todo-frontend`) already match what Terraform creates as long as `project_name = "todo"` in `terraform.tfvars` — change both together if you rename it.

## Notes / things you'll likely want to adjust

- **Region**: set once via `AWS_REGION` env var at the top of `deploy.yml`.
- **Zero-downtime**: `wait-for-service-stability: true` makes the job wait for ECS to finish rolling out before finishing — remove if you don't want CI to block on that.
- **DB migrations**: not included. If you use Alembic, add a step before deploy that runs a one-off ECS task (`aws ecs run-task`) executing `alembic upgrade head` against the same task definition/image.
- **Postgres on ECS instead of RDS**: possible but not recommended for anything beyond a demo — you'd lose managed backups/failover and need an EFS volume for persistence. If you specifically want that, say so and I'll add a stateful task definition + service.
