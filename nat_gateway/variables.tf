variable "private_route_tables" {
  type = list(string)
}

variable "number_nat_gateways" {
  type    = number
  default = 1
}

variable "public_subnets" {
  type = list(string)
}

variable "tags" {
  type        = map(string)
  description = "Optional extra tags"
  default     = {}
}
