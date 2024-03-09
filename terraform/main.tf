terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.38.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

data "aws_ecr_repository" "repository" {
  name = local.ecs_container_name
}

locals {
  app_name = "aluraflix"
  # VPC
  vpc_id      = module.vpc.vpc_id
  vpc_cidr    = "10.0.0.0/16"
  vpc_subnets = module.vpc.subnets
  vpc_azs     = slice(data.aws_availability_zones.available.names, 0, 2)

  # Security Groups
  sg_allow_http = module.vpc.sg_allow_http_id
  sg_dafault    = module.vpc.sg_default_id

  # Auto Scalling
  asg_arn = module.ec2.asg_arn

  # Load Balancer
  lb_target_group = module.ec2.lb_target_group
}

# Define ECS values
locals {
  ecs_cluster_name   = "cluster-${local.app_name}"
  ecs_service_name   = "service-${local.app_name}"
  ecs_capacity_name  = "capacity-provider-${local.app_name}"
  ecs_container_name = "${local.app_name}-api"
  ecs_image          = "${data.aws_ecr_repository.repository.repository_url}:${data.aws_ecr_repository.repository.most_recent_image_tags[0]}"
}

module "vpc" {
  source = "./infra/vpc"

  name        = local.app_name
  cidr        = local.vpc_cidr
  azs         = local.vpc_azs
  qtd_subnets = 2

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
}

module "ec2" {
  source = "./infra/ec2"

  name           = local.app_name
  key            = "ecs-prod"
  instance_image = "ami-0017b31c3b5cc98fb"
  vpc_id         = local.vpc_id
  subnets        = local.vpc_subnets
  sg_allow_http  = local.sg_allow_http
  sg_default     = local.sg_dafault
  cluster_name   = local.ecs_cluster_name
  production     = true

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
}

module "ecs" {
  source = "./infra/ecs"

  name            = local.app_name
  image           = local.ecs_image
  container_name  = local.ecs_container_name
  cluster_name    = local.ecs_cluster_name
  service_name    = local.ecs_service_name
  capacity_name   = local.ecs_capacity_name
  asg_arn         = local.asg_arn
  lb_target_group = local.lb_target_group
  subnets         = local.vpc_subnets

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
}
