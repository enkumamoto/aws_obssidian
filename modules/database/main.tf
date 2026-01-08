locals {
  avaliability_zones = [for s in data.aws_subnet.private_app_subnets : s.availability_zone]
  # avaliability_zones = [for s in data.aws_subnet.public_subnets : s.availability_zone]
  tags   = merge(var.tags_to_append, { Environment = var.environment })
  vpc_id = data.aws_subnet.private_app_subnets[0].vpc_id
  # vpc_id         = data.aws_subnet.public_subnets[0].vpc_id
  db_domain_name = "postgres.${var.environment}"
}

output "avaliability_zones" {
  value = local.avaliability_zones
}

resource "aws_db_subnet_group" "default" {
  name       = "default_db_subnet_group_postgres_${var.environment}"
  subnet_ids = var.vpc_config_private_app_subnet_ids
  # subnet_ids = var.vpc_config_public_subnet_ids

  tags = merge(local.tags, { Name = "default_db_subnet_group_postgres_${var.environment}" })
}

resource "aws_security_group" "allow_postgres" {
  name        = "allow_postgres_${var.environment}"
  description = "Allow Postgres inbound traffic"
  vpc_id      = data.aws_subnet.private_app_subnets[0].vpc_id
  # vpc_id = data.aws_subnet.public_subnets[0].vpc_id

  ingress {
    description = "Allow Postgres"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [for s in data.aws_subnet.private_app_subnets : s.cidr_block]
    # cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [for s in data.aws_subnet.private_app_subnets : s.cidr_block]
    # cidr_blocks = ["0.0.0.0/0"]

  }

  tags = merge(local.tags, { Name = "allow_postgres_${var.environment}" })
}

resource "aws_rds_cluster" "obsidian_postgresql" {
  cluster_identifier   = "obsidian-datapolling"
  engine               = "aurora-postgresql"
  engine_mode          = "provisioned"
  enable_http_endpoint = true

  serverlessv2_scaling_configuration {
    max_capacity = 8.0
    min_capacity = 0.5
  }

  db_subnet_group_name    = aws_db_subnet_group.default.name
  database_name           = var.initial_db_name
  master_username         = var.master_username
  master_password         = var.master_password
  backup_retention_period = 7
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
  vpc_security_group_ids = [
    aws_security_group.allow_postgres.id
  ]

  depends_on = [aws_db_subnet_group.default, aws_security_group.allow_postgres]

  tags = merge(local.tags, { Name = "postgres_db_${var.environment}" })
}

resource "aws_rds_cluster_instance" "obsidian_postgresql_instance" {
  count = 1

  identifier                 = "obsidian-datapolling-instance-${count.index}"
  cluster_identifier         = aws_rds_cluster.obsidian_postgresql.id
  instance_class             = "db.serverless"
  engine                     = "aurora-postgresql"
  engine_version             = "15.4"
  publicly_accessible        = false
  apply_immediately          = true
  auto_minor_version_upgrade = true

  tags = merge(local.tags, { Name = "postgres_db_instance_${var.environment}" })
}

output "db_host" {
  value = aws_rds_cluster.obsidian_postgresql.endpoint
}

output "db_name" {
  value = aws_rds_cluster.obsidian_postgresql.database_name
}
