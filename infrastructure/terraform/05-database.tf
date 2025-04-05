resource "aws_rds_cluster" "this" {
  cluster_identifier      = var.cluster_identifier
  engine                  = var.engine
  engine_mode             = var.engine_mode
  master_username         = var.master_username
  master_password         = var.master_password
  database_name           = var.database_name
  backup_retention_period = var.backup_retention_period
  storage_encrypted       = true
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.database.id]

  tags = merge(
    {
      Name        = "${var.cluster_identifier}-cluster"
      Environment = var.environment
    }
  )
}

resource "aws_rds_cluster_instance" "this" {
  count                = var.instance_count
  identifier           = "${var.cluster_identifier}-instance-${count.index}"
  cluster_identifier   = aws_rds_cluster.this.cluster_identifier
  instance_class       = var.instance_class
  engine               = var.engine
  engine_version       = var.engine_version
  db_subnet_group_name = aws_db_subnet_group.this.name
  publicly_accessible  = false

  tags = merge(
    {
      Name        = "${var.cluster_identifier}-instance-${count.index}"
      Environment = var.environment
    }
  )

  lifecycle {
    ignore_changes = [engine_version]
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.cluster_identifier}-subnet-group"
  subnet_ids = var.database_subnets

  tags = merge(
    {
      Name        = "${var.cluster_identifier}-subnet-group"
      Environment = var.environment
    }
  )
}
