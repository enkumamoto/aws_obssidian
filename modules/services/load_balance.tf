#Public LB
resource "aws_lb" "public_alb" {
  name            = "obsidian-public-alb-${var.environment}"
  internal        = false # Public facing ALB
  security_groups = [aws_security_group.allow_service_access.id]
  subnets         = var.vpc_config_public_subnet_ids

  load_balancer_type = "application"

  tags = merge(local.tags, { Name = "obsidian-public-alb-${var.environment}" })
}

output "public_alb_dns_name" {
  value = aws_lb.public_alb.dns_name
}

resource "aws_lb_target_group" "public_alb_target_group" {
  name        = "obsidian-public-target-group"
  target_type = "ip" # Use ip para tarefas ECS
  port        = 3000 # Matches container port
  protocol    = "HTTP"
  vpc_id      = local.vpc_id

  health_check {
    port                = 3000
    protocol            = "HTTP"
    interval            = 300
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    path                = "/api/health"
  }

  tags = merge(local.tags, { Name = "obsidian-public-alb-target-group-${var.environment}" })
}

resource "aws_lb_listener" "public_alb_listener" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public_alb_target_group.arn
  }
}

resource "aws_lb_listener_rule" "public_alb_listener_rule" {
  listener_arn = aws_lb_listener.public_alb_listener.arn
  priority     = 50000

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public_alb_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/static/*"]
    }
  }

  depends_on = [
    aws_lb_listener.public_alb_listener
  ]

  tags = merge(local.tags, { Name = "obsidian-public-alb-listener-rule-${var.environment}" })
}

# apiService LB
resource "aws_lb" "apiService_alb" {
  name            = "obsidian-apiService-alb"
  internal        = true
  security_groups = [aws_security_group.allow_service_access.id]
  subnets         = var.vpc_config_private_app_subnet_ids

  load_balancer_type = "application"

  tags = merge(local.tags, { Name = "obsidian-apiService-alb-${var.environment}" })
}

output "apiService_alb_dns_name" {
  value = aws_lb.apiService_alb.dns_name
}

resource "aws_lb_target_group" "apiService_alb_target_group" {
  name        = "obsidian-apiService"
  target_type = "ip" # Use ip para tarefas ECS
  port        = 8080 # Matches container port
  protocol    = "HTTP"
  vpc_id      = local.vpc_id

  health_check {
    port                = 8080
    protocol            = "HTTP"
    interval            = 300
    timeout             = 10
    unhealthy_threshold = 3
    path                = "/health"
  }

  tags = merge(local.tags, { Name = "obsidian-apiService-alb-target-group-${var.environment}" })
}

resource "aws_lb_listener" "apiService_alb_listener" {
  load_balancer_arn = aws_lb.apiService_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apiService_alb_target_group.arn
  }
}

resource "aws_lb_listener_rule" "apiService_alb_listener_rule-1" {
  listener_arn = aws_lb_listener.apiService_alb_listener.arn
  priority     = 49999

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apiService_alb_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/static/*", "AND"]
    }
  }

  depends_on = [
    aws_lb_listener.apiService_alb_listener
  ]

  tags = merge(local.tags, { Name = "obsidian-apiService-alb-listener-rule-${var.environment}" })
}

resource "aws_lb_listener_rule" "apiService_alb_listener_rule-2" {
  listener_arn = aws_lb_listener.apiService_alb_listener.arn
  priority     = 50000

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apiService_alb_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/static/*", "AND"]
    }
  }

  depends_on = [
    aws_lb_listener.apiService_alb_listener
  ]

  tags = merge(local.tags, { Name = "obsidian-apiService-alb-listener-rule-${var.environment}" })
}
