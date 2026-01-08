locals {
  tags   = merge(var.tags_to_append, { Environment = var.environment })
  vpc_id = var.vpc_id
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "obsidian-${var.environment}-Cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  depends_on = [var.db_host]

  tags = local.tags
}

resource "aws_ecs_cluster_capacity_providers" "capacity_provider" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = ["FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls_${var.environment}"
  description = "Allow TLS inbound traffic"
  vpc_id      = local.vpc_id

  ingress {
    description      = "Allow TLS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.tags
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}
