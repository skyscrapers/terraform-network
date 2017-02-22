variable "cidr" {}

variable "newbits" {
  description = "see https://www.terraform.io/docs/configuration/interpolation.html#cidrsubnet_iprange_newbits_netnum_"
  default     = 8
}

variable "netnum" {
  description = "first number of subnet to start of (ex I want a 10.1,10.2,10.3 subnet I specify 1) https://www.terraform.io/docs/configuration/interpolation.html#cidrsubnet_iprange_newbits_netnum_"
  default     = 0
}

variable "vpc_id" {
  description = "ID of the VPC where we want to deploy the subnet in"
}

variable "name" {
  description = "Name of the subnets"
}

variable "tags" {
  type        = "map"
  description = "Optional Tags"
  default     = {}
}

variable "project" {
  description = "Project name"
}

variable "environment" {
  description = "Environment name"
}

variable "num_subnets" {
  default = "3"
}
