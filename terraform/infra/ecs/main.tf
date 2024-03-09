terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.38.0"
    }
  }

  required_version = ">= 1.2.0"
}

resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
  tags = var.tags
}

resource "aws_ecs_capacity_provider" "capacity_provider" {
  name = "capacity-provider-${var.name}"

  auto_scaling_group_provider {
    auto_scaling_group_arn = var.asg_arn

    managed_scaling {
      maximum_scaling_step_size = 10
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 90
    }
  }

  tags = var.tags
}

resource "aws_ecs_cluster_capacity_providers" "cluster_capacity_provider" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = [aws_ecs_capacity_provider.capacity_provider.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.capacity_provider.name
  }

  depends_on = [aws_ecs_capacity_provider.capacity_provider]
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = var.name
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  execution_role_arn       = "arn:aws:iam::590183733571:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "${var.container_name}"
      image     = "${var.image}"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 0
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  tags = var.tags
}

resource "aws_ecs_service" "service" {
  name            = "service-${var.name}"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 2

  force_new_deployment = true

  triggers = {
    redeployment = timestamp()
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.capacity_provider.id
    weight            = 100
  }

  load_balancer {
    target_group_arn = var.lb_target_group
    container_name   = var.container_name
    container_port   = 80
  }

  placement_constraints {
    type = "distinctInstance"
  }

  tags = var.tags

  depends_on = [aws_ecs_cluster_capacity_providers.cluster_capacity_provider]
}
