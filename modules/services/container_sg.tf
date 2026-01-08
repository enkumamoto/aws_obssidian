resource "aws_security_group" "container_sg" {
  name        = "container_${var.environment}_sg"
  description = "Allow obsidian container traffic"
  vpc_id      = local.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }

  tags = merge(local.tags, { Name = "container_sg_${var.environment}" })
}

output "container_sg_id" {
  value = aws_security_group.container_sg.id
}

resource "aws_vpc_security_group_ingress_rule" "container_HTTP_ingrees_role" {
  security_group_id = aws_security_group.container_sg.id
  description       = "HTTP ingress from the public ALB"

  from_port                    = 0
  ip_protocol                  = "-1"
  to_port                      = 0
  referenced_security_group_id = aws_security_group.lb_pub_sg.id

  tags = merge(local.tags, { Name = "container_sg_${var.environment}" })
}

resource "aws_vpc_security_group_ingress_rule" "container_ingrees_role" {
  security_group_id = aws_security_group.container_sg.id
  description       = "Ingress from other containers in the same security group"

  from_port                    = 0
  ip_protocol                  = "-1"
  to_port                      = 0
  referenced_security_group_id = aws_security_group.container_sg.id

  tags = merge(local.tags, { Name = "container_sg_${var.environment}" })
}

resource "aws_vpc_security_group_ingress_rule" "container_elasticache_role" {
  security_group_id = aws_security_group.container_sg.id
  description       = "Valkey Cache"

  from_port                    = 6379
  ip_protocol                  = "tcp"
  to_port                      = 6380
  referenced_security_group_id = aws_security_group.container_sg.id

  tags = merge(local.tags, { Name = "container_sg_${var.environment}" })
}

resource "aws_vpc_security_group_ingress_rule" "container_lbpvt_ingrees_role" {
  security_group_id = aws_security_group.container_sg.id
  description       = "Ingress from the internal ALB"

  from_port                    = 0
  ip_protocol                  = "-1"
  to_port                      = 0
  referenced_security_group_id = aws_security_group.lb_pvt_sg.id

  tags = merge(local.tags, { Name = "container_sg_${var.environment}" })
}
