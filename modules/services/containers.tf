locals {
  vpc_id                   = var.vpc_id
  microservices_dns_suffix = "ms.${var.environment}"
  secret_entries           = [for v in var.service_secrets : "\"${v}\""]
}

resource "aws_ecs_service" "apiService-taskDefinition_ecs_service" {
  name            = "apiService-taskDefinition_${var.environment}"
  cluster         = var.ecs_cluster_id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.apiService-taskDefinition.arn
  desired_count   = 1

  network_configuration {
    subnets = var.vpc_config_private_app_subnet_ids
    security_groups = [
      aws_security_group.allow_service_access.id
    ]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.apiService_alb_target_group.arn
    container_name   = "obsidian-api-Service"
    container_port   = 8080
  }

  depends_on = [
    aws_security_group.allow_service_access
  ]

  tags = local.tags
}

resource "aws_ecs_task_definition" "apiService-taskDefinition" {
  family                   = "apiService-taskDefinition_${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name  = "obsidian-api-Service"
      image = "${var.account_cross_id}.dkr.ecr.${var.region}.amazonaws.com/obsidian/obsidian-api:latest"
      # image     = "${aws_ecr_repository.obsidian-api.repository_url}:latest" # Substituir com a imagem da sua API
      essential = true
      environment = [
        {
          name  = "obsidian__MessageBroker__Type",
          value = "AmazonSqs"
        },
        {
          name  = "obsidian__MessageBroker__AmazonSqs__Region",
          value = "${var.region}"
        },
        {
          name  = "obsidian__Cache__IsEnabled",
          value = "true"
        },
        {
          name  = "obsidian__Cache__ElastiCache__ClusterEndpoint",
          value = "dashboard-cache-ina0io.serverless.use2.cache.amazonaws.com:6379"
        },
        {
          name  = "obsidian__MessageBroker__AmazonSqs__Scope",
          value = "stg"
        },
        {
          name  = "obsidian__SMTP__SupportEmail__Name",
          value = "Supportobsidian"
        },
        {
          name  = "COPILOT_SERVICE_DISCOVERY_ENDPOINT",
          value = "dev.obsidian.local"
        },
        {
          name  = "AWS__Region",
          value = "${var.region}"
        },
        {
          name  = "obsidian__Environment",
          value = "stg"
        },
        {
          name  = "obsidian__SMTP__SupportEmail__Address",
          value = "obsidian@your_domain"
        },
        {
          name  = "obsidian__SMTP__IsEnabled",
          value = "false"
        }
      ]
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
      # Configuração opcional para monitoramento e customização do Nginx
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/obsidian-api"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "uiService-taskDefinition_ecs_service" {
  name            = "uiService-taskDefinition_${var.environment}"
  cluster         = var.ecs_cluster_id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.uiService-taskDefinition.arn
  desired_count   = 1

  network_configuration {
    subnets = var.vpc_config_private_app_subnet_ids
    security_groups = [
      aws_security_group.allow_service_access.id
    ]
  }

  # Configuração de load balancer para Nginx responder nas portas configuradas
  load_balancer {
    target_group_arn = aws_lb_target_group.public_alb_target_group.arn
    container_name   = "obsidian-ui-Service"
    container_port   = 3000
  }

  depends_on = [
    aws_security_group.allow_service_access
  ]

  tags = local.tags
}

resource "aws_ecs_task_definition" "uiService-taskDefinition" {
  family                   = "uiService-taskDefinition_${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name  = "obsidian-ui-Service"
      image = "${var.account_cross_id}.dkr.ecr.${var.region}.amazonaws.com/obsidian/obsidian-ui:latest"
      # image     = "${aws_ecr_repository.obsidian-ui.repository_url}:latest" # Substituir com a imagem da sua API
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]

      environment = [
        {
          name  = "obsidian_API_URL",
          value = "http://${aws_lb.apiService_alb.dns_name}/api"
        },
        {
          name  = "port",
          value = "3000"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/obsidian-api"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "datapollingService-taskDefinition_ecs_service" {
  name            = "datapollingService-taskDefinition_${var.environment}"
  cluster         = var.ecs_cluster_id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.datapollingService-taskDefinition.arn
  desired_count   = 1

  network_configuration {
    subnets = var.vpc_config_private_app_subnet_ids
    security_groups = [
      aws_security_group.allow_service_access.id
    ]
  }
  # load_balancer {
  #   target_group_arn = aws_lb_target_group.datapollingService_alb_target_group.arn
  #   container_name   = "datapolling-Service"
  #   container_port   = 8080
  # }

  depends_on = [
    aws_security_group.allow_service_access
  ]

  tags = local.tags
}

resource "aws_ecs_task_definition" "datapollingService-taskDefinition" {
  family                   = "datapollingService-taskDefinition_${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "datapolling-Service"
      image     = "${var.account_cross_id}.dkr.ecr.${var.region}.amazonaws.com/obsidian/datapolling:latest"
      essential = true
      environment = [

        {
          name  = "obsidian__MessageBroker__Type",
          value = "AmazonSqs"
        },
        {
          name  = "obsidian__MessageBroker__AmazonSqs__Region",
          value = "${var.region}"
        },
        {
          name  = "obsidian__JobScheduler__Quartz__Store__PersistenceStore__Type",
          value = "Postgres"
        },
        {
          name  = "obsidian__MessageBroker__AmazonSqs__Scope",
          value = "${var.environment}"
        },
        {
          name  = "obsidian__JobScheduler__Quartz__Store",
          value = "InMemory"
        },
        {
          name  = "OTEL_SERVICE_NAME",
          value = "datapolling"
        },
        {
          name  = "obsidian__SMTP__SupportEmail__Name",
          value = "Supportobsidian"
        },
        {
          name  = "AWS__Region",
          value = "${var.region}"
        },
        {
          name  = "Logging__LogLevel__obsidian",
          value = "Debug"
        },
        {
          name  = "obsidian__Environment",
          value = "${var.environment}"
        },
        {
          name  = "obsidian__SMTP__SupportEmail__Address",
          value = "obsidian@your_domain"
        },
        {
          name  = "obsidian__SMTP__IsEnabled",
          value = "false"
        },
        {
          name  = "obsidian__Athena__ResultLocation",
          value = "obsidian-monitor-metadata-staging"
        },
        {
          name  = "port",
          value = "8080"
        }
      ]

      # secrets = [
      #   {
      #     name      = "obsidian__JobScheduler__Quartz__PersistenceStore__ConnectionString",
      #     valueFrom = "/copilot/obsidian/dev/secrets/obsidian__JobScheduler__Quartz__PersistenceStore__ConnectionString"
      #   }
      # ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/obsidian-datapolling"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    }
  ])
}
