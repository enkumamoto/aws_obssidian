resource "aws_security_group" "allow_service_access" {
  name        = "allow_obsidian_service_access_${var.environment}_${substr(uuid(), 0, 3)}_sg"
  description = "Allow obsidian alb inbound traffic"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
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

  tags = merge(local.tags, { Name = "allow_obsidian_service_access_${var.environment}" })
}
