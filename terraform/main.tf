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

locals {
  app_name = "aluraflix"
  # VPC
  vpc_id      = module.vpc.vpc_id
  vpc_cidr    = "10.0.0.0/16"
  vpc_subnets = module.vpc.subnets
  azs         = slice(data.aws_availability_zones.available.names, 0, 2)
  # Security Groups
  sg_allow_http = module.vpc.sg_allow_http_id
  sg_dafault    = module.vpc.sg_default_id
  # Auto-scaling Group
  asg_arn = module.ec2.asg_arn
  #
  lb_target_group = module.ec2.lb_target_group
}

# Define ECS values
locals {
  ecs_cluster_name     = "cluster-${local.app_name}"
  ecs_image_name       = "aluraflix-api"
  ecs_image_version    = "latest"
  ecs_image_repository = "590183733571.dkr.ecr.us-east-2.amazonaws.com"
  ecs_image            = "${local.ecs_image_repository}/${local.ecs_image_name}:${local.ecs_image_version}"
}

module "vpc" {
  source = "./modules/vpc"

  name        = local.app_name
  cidr        = local.vpc_cidr
  azs         = local.azs
  qtd_subnets = 2

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
}

module "ec2" {
  source = "./modules/ec2"

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
  source = "./modules/ecs"

  name            = local.app_name
  image           = local.ecs_image
  container_name  = local.ecs_image_name
  cluster_name    = local.ecs_cluster_name
  asg_arn         = local.asg_arn
  lb_target_group = local.lb_target_group
  subnets         = local.subnets

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
}
