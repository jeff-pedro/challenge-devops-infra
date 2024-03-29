variable "name" {
  type = string
}

variable "tags" {
  type = object({
    Terraform   = string,
    Environment = string
  })
}

variable "image" {
  type = string
}

variable "container_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "capacity_name" {
  type = string
}

variable "asg_arn" {
  type = string
}

variable "lb_target_group" {
  type = string
}

variable "subnets" {
  default = null
}

variable "execution_role" {
  type = string
}
