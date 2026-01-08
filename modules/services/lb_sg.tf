resource "aws_security_group" "lb_pvt_sg" {
  name        = "lb_pvt_${var.environment}_sg"
  description = "Allow obsidian alb private traffic"
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

  tags = merge(local.tags, { Name = "lb_pvt_sg_${var.environment}" })
}

output "lb_pvt_sg_id" {
  value = aws_security_group.lb_pvt_sg.id
}

resource "aws_vpc_security_group_ingress_rule" "lb_elasticache_role" {
  security_group_id = aws_security_group.lb_pvt_sg.id
  description       = "Valkey Cache"

  from_port                    = 6379
  ip_protocol                  = "tcp"
  to_port                      = 6380
  referenced_security_group_id = aws_security_group.container_sg.id

  tags = merge(local.tags, { Name = "lb_pvt_sg_${var.environment}" })
}

resource "aws_vpc_security_group_ingress_rule" "lb_container_ingrees_role" {
  security_group_id = aws_security_group.lb_pvt_sg.id
  description       = "Ingress from other containers in the same security group"

  from_port                    = 0
  ip_protocol                  = "-1"
  to_port                      = 0
  referenced_security_group_id = aws_security_group.container_sg.id

  tags = merge(local.tags, { Name = "lb_pvt_sg_${var.environment}" })
}

resource "aws_security_group" "lb_pub_sg" {
  name        = "lb_pub_${var.environment}_sg"
  description = "Allow from anyone on port 80"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  tags = merge(local.tags, { Name = "lb_pub_sg_${var.environment}" })
}

output "lb_pub_sg_id" {
  value = aws_security_group.lb_pub_sg.id

}
