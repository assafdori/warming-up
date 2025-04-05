variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "acme"
}

variable "environment" {
  description = "The environment to deploy to (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "database_subnets" {
  description = "List of database subnet CIDR blocks"
  type        = list(string)
}

variable "cluster_identifier" {
  description = "The identifier for the RDS cluster"
  type        = string
  default     = "acme-cluster"
}
variable "engine" {
  description = "The database engine to use (e.g., aurora, mysql, postgres)"
  type        = string
  default     = "aurora-postgresql"
}
variable "engine_mode" {
  description = "The engine mode for the database (e.g., provisioned, serverless)"
  type        = string
  default     = "provisioned"
}
variable "master_username" {
  description = "The master username for the database"
  type        = string
  default     = "admin"
}
variable "master_password" {
  description = "The master password for the database"
  type        = string
  default     = "password123"
  sensitive   = true
}
variable "database_name" {
  description = "The name of the initial database to create"
  type        = string
  default     = "acme-db"
}
variable "backup_retention_period" {
  description = "The number of days to retain backups"
  type        = number
  default     = 0
}
variable "instance_class" {
  description = "The instance class for the RDS instances"
  type        = string
  default     = "db.t3.medium"
}
variable "instance_count" {
  description = "The number of RDS instances to create"
  type        = number
  default     = 1
}
variable "engine_version" {
  description = "The version of the database engine to use"
  type        = string
  default     = "5.6"
}
