variable "name" {
  type = string
}

variable "cidr" {
  type = string
}

variable "tags" {
  type = object({
    Terraform   = string,
    Environment = string
  })
}

variable "azs" {
  type = list(string)
}

variable "qtd_subnets" {
  description = "Quantity of subnets used for VPC"
  type = number
  default = 1
}
