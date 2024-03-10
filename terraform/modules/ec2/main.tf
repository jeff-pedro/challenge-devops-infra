terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.38.0"
    }
  }

  required_version = ">= 1.2.0"
}

resource "aws_key_pair" "ssh_key" {
  key_name   = var.key
  public_key = file("${var.key}.pub")
}

# Template for ECS agent configuration bash script
data "template_file" "ecs_script" {
  template = file("${path.module}/ecs.tpl")
  vars = {
    cluster_name = "${var.cluster_name}"
  }
}

resource "aws_launch_template" "launch_template" {
  name          = "lt-ecs-asg-${var.name}"
  image_id      = var.instance_image
  instance_type = var.instance_size

  key_name               = var.key
  vpc_security_group_ids = [var.sg_allow_http, var.sg_default]
  iam_instance_profile {
    name = "ecsInstanceRole"
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags,
      {
        Name = "ecs-instance"
      }
    )
  }

  user_data = base64encode(data.template_file.ecs_script.rendered)
}

resource "aws_autoscaling_group" "ecs_asg" {
  name             = "infra-ecs-cluster-${var.name}"
  desired_capacity = 2
  max_size         = 3
  min_size         = 1

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  vpc_zone_identifier = [for subnet in var.subnets : subnet.id]

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}

resource "aws_lb" "ecs_alb" {
  name               = "ecs-alb-${var.name}"
  internal           = false
  load_balancer_type = "application"

  security_groups = [var.sg_allow_http, var.sg_default]
  subnets         = [for subnet in var.subnets : subnet.id]


  enable_deletion_protection = false

  tags = merge(
    var.tags,
    {
      Name = "ecs-alb-${var.name}"
    }
  )

  count = var.production ? 1 : 0
}

resource "aws_lb_target_group" "ecs_tg" {
  name        = "ecs-tg-${var.name}"
  port        = "80"
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    path = "/"
  }

  tags = var.tags

  count = var.production ? 1 : 0
}

resource "aws_lb_listener" "ecs_alb_listener" {
  load_balancer_arn = aws_lb.ecs_alb[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg[0].arn
  }

  count = var.production ? 1 : 0
}
