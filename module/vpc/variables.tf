variable "cidr_range" {
  type        = string
  description = "CIDR range for the account"
}

variable "vpc_suffix" {
  type        = string
  description = "Name of the VPC suffix"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "tags" {
  type        = map(any)
  description = "Map of tags for repository"
}