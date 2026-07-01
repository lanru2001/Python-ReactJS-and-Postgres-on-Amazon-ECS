aws_region   = "us-east-1"
project_name = "todo"
environment  = "production"

github_org    = "your-github-org-or-username"
github_repo   = "your-repo-name"
github_branch = "main"

# Leave empty for HTTP-only (fine for a quick test). Set to an ACM cert ARN
# in the same region as the ALB to enable HTTPS.
certificate_arn = ""

# Sizing - defaults are modest/cheap; bump these for real production traffic
backend_desired_count  = 2
frontend_desired_count = 2
db_instance_class      = "db.t4g.micro"
db_multi_az             = false
