variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Short name used as a prefix for resource names"
  type        = string
  default     = "todo"
}

variable "environment" {
  description = "Environment name (e.g. production, staging)"
  type        = string
  default     = "production"
}

# ---------------------------------------------------------------------------
# Networking
# ---------------------------------------------------------------------------

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "availability_zones" {
  description = "AZs to spread subnets across (2 is the minimum for an ALB + Multi-AZ RDS)"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets (ALB, NAT gateways)"
  type        = list(string)
  default     = ["10.20.0.0/24", "10.20.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDRs for private subnets (ECS tasks, RDS)"
  type        = list(string)
  default     = ["10.20.10.0/24", "10.20.11.0/24"]
}

variable "single_nat_gateway" {
  description = "Use one NAT gateway instead of one per AZ (cheaper, less resilient - fine for dev/staging)"
  type        = bool
  default     = true
}

# ---------------------------------------------------------------------------
# Database
# ---------------------------------------------------------------------------

variable "db_name" {
  description = "Postgres database name"
  type        = string
  default     = "todo"
}

variable "db_username" {
  description = "Postgres master username"
  type        = string
  default     = "todo_admin"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "db_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
  default     = 20
}

variable "db_engine_version" {
  description = "Postgres engine version"
  type        = string
  default     = "16.4"
}

variable "db_multi_az" {
  description = "Enable Multi-AZ RDS failover (recommended for production)"
  type        = bool
  default     = false
}

variable "db_backup_retention_days" {
  description = "Number of days to retain automated RDS backups"
  type        = number
  default     = 7
}

variable "db_deletion_protection" {
  description = "Prevent accidental RDS deletion"
  type        = bool
  default     = false
}

# ---------------------------------------------------------------------------
# ECS - backend
# ---------------------------------------------------------------------------

variable "backend_container_port" {
  type    = number
  default = 8000
}

variable "backend_cpu" {
  description = "Fargate task vCPU units (256 = 0.25 vCPU)"
  type        = number
  default     = 256
}

variable "backend_memory" {
  description = "Fargate task memory in MB"
  type        = number
  default     = 512
}

variable "backend_desired_count" {
  type    = number
  default = 2
}

# ---------------------------------------------------------------------------
# ECS - frontend
# ---------------------------------------------------------------------------

variable "frontend_container_port" {
  type    = number
  default = 80
}

variable "frontend_cpu" {
  type    = number
  default = 256
}

variable "frontend_memory" {
  type    = number
  default = 512
}

variable "frontend_desired_count" {
  type    = number
  default = 2
}

# ---------------------------------------------------------------------------
# ALB / TLS
# ---------------------------------------------------------------------------

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS on the ALB. Leave empty to serve HTTP only (fine for testing, not for production)."
  type        = string
  default     = ""
}

variable "api_path_pattern" {
  description = "ALB listener rule path pattern routed to the backend service; everything else goes to the frontend"
  type        = string
  default     = "/api/*"
}

# ---------------------------------------------------------------------------
# GitHub OIDC (for the deploy.yml workflow)
# ---------------------------------------------------------------------------

variable "github_org" {
  description = "GitHub organization or username that owns the repo"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name (without org prefix)"
  type        = string
}

variable "github_branch" {
  description = "Branch allowed to assume the deploy role via OIDC. Use '*' to allow any branch (not recommended)."
  type        = string
  default     = "main"
}
