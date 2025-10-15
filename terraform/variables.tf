variable "region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-west-2"
}

variable "app_name" {
  description = "Application name (used for resource naming)"
  type        = string
  default     = "myapp"
}

variable "ecr_repository_name" {
  description = "ECR repository name (derived from GitHub repository)"
  type        = string
  default     = "strapi-for-sirpi-demo"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "production"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "container_cpu" {
  description = "CPU units for container (256 = 0.25 vCPU)"
  type        = number
  default     = 256
}

variable "container_memory" {
  description = "Memory for container in MB"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 2
}

variable "acm_certificate_arn" {
  description = "ARN of ACM certificate for HTTPS listener. Leave as placeholder to deploy HTTP-only (not recommended for production)"
  type        = string
  default     = "arn:aws:acm:REGION:ACCOUNT:certificate/PLACEHOLDER"
}

variable "enable_https" {
  description = "Enable HTTPS listener (requires valid ACM certificate)"
  type        = bool
  default     = false
}
