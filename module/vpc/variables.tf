variable "cidr_range" {
  type    = string
  description = "CIDR range for the account"
}

variable "vpc_name" {
  type    = string
  description = "Name of the VPC"
}

variable "environment" {
  type    = string
  description = "Environment name"
}
