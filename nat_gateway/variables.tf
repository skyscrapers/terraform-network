variable "private_route_tables" {
  type = "list"
}

variable "number_nat_gateways" {
  default = "1"
}

variable "public_subnets" {
  type = "list"
}

variable "tags" {
  type        = "map"
  description = "Optional extra tags"
  default     = {}
}
