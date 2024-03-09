variable "tags" {
  type = object({
    Terraform   = string,
    Environment = string
  })
}

variable "name" {
  type = string
}

variable "production" {
  default = false
}

variable "key" {
  type = string
}

variable "sg_allow_http" {
  type = string
}

variable "sg_default" {
  type = string
}

variable "subnets" {
  default = null
}

variable "vpc_id" {
  type = string
}

variable "instance_image" {
  description = "AWS image ecs-optimized"
  type        = string
}

variable "instance_size" {
  description = "Size of AWS intance"
  type        = string
  default     = "t2.micro"
}

variable "cluster_name" {
  type = string
}
