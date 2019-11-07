variable "cidr" {
  description = "CIDR block you use in your VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of AZs to use for the subnets. Defaults to all available AZs when not specified (looped over sequentially for the amount of subnets)"
  type        = list(string)
  default     = null
}

variable "newbits" {
  description = "Newbits to use for generating the subnets. For more information, see the [cidrsubnet function docs](https://www.terraform.io/docs/configuration/functions/cidrsubnet.html)"
  type        = number
  default     = 8
}

variable "netnum" {
  description = "Netnum to use for generating the EKS worker subnets. For more information, see the [cidrsubnet function docs](https://www.terraform.io/docs/configuration/functions/cidrsubnet.html)"
  type        = number
  default     = 0
}

variable "vpc_id" {
  description = "ID of the VPC where we want to deploy the subnet"
  type        = string
}

variable "role" {
  description = "Role for the subnets. Example values are `app`, `lb`, `db`, ..."
  type        = string
}

variable "visibility" {
  description = "Visibility of this subnet. Valid values are `public` or `private`"
  type        = string
}

variable "tags" {
  description = "Optional Tags"
  type        = map(string)
  default     = {}
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "num_subnets" {
  description = "Amount of subnets to create"
  type        = number
  default     = 3
}

variable "route_tables" {
  description = "Route tables to attach the subnets to"
  type        = list(string)
  default     = []
}

variable "num_route_tables" {
  description = "Amount of route tables to attach the subnets to"
  type        = number
  default     = 0
}
