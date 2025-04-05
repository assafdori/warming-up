# ----------------------------
# VPC and Subnets
# ----------------------------

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

resource "aws_subnet" "private" {
  count                   = length(var.private_subnets)
  cidr_block              = element(var.private_subnets, count.index)
  vpc_id                  = aws_vpc.this.id
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-${var.environment}-private-subnet-${count.index}"

    "kubernetes.io/role/internal-elb"                      = 1
    "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"

  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  cidr_block              = element(var.public_subnets, count.index)
  vpc_id                  = aws_vpc.this.id
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public-subnet-${count.index}"

    "kubernetes.io/role/elb"                               = 1
    "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"
  }
}

resource "aws_subnet" "database" {
  count                   = length(var.database_subnets)
  cidr_block              = element(var.database_subnets, count.index)
  vpc_id                  = aws_vpc.this.id
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-${var.environment}-database-subnet-${count.index}"

    "kubernetes.io/role/internal-elb"                      = 1
    "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"
  }
}

# ----------------------------
# Route Tables and Associations
# ----------------------------

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-${var.environment}-private-route-table"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-${var.environment}-public-route-table"
  }
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-${var.environment}-database-route-table"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "database" {
  count          = length(aws_subnet.database)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}

# ----------------------------
# Security Groups
# ----------------------------

resource "aws_security_group" "app" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-${var.environment}-app-sg"
  }
}

resource "aws_security_group_rule" "app_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.app.id
  cidr_blocks       = ["0.0.0.0/0"] # ⚠️ Consider restricting for production
}

resource "aws_security_group_rule" "app_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.app.id
  cidr_blocks       = [aws_vpc.this.cidr_block]
}

resource "aws_security_group" "database" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-${var.environment}-database-sg"
  }
}

resource "aws_security_group_rule" "database_ingress" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.database.id
  source_security_group_id = aws_security_group.app.id
}

resource "aws_security_group_rule" "database_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.database.id
  cidr_blocks       = [aws_vpc.this.cidr_block]
}

resource "aws_security_group" "elb" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-${var.environment}-elb-sg"
  }
}

resource "aws_security_group_rule" "elb_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.elb.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "elb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.elb.id
  cidr_blocks       = [aws_vpc.this.cidr_block]
}
