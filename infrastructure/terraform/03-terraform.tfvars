project_name = "acme"
environment  = "dev"

aws_region = "eu-central-1"

vpc_cidr = "10.0.0.0/16"

database_subnets = ["10.0.100.0/24", "10.0.200.0/24"]
private_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnets   = ["10.0.10.0/24", "10.0.20.0/24"]
