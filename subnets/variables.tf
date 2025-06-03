variable "cidr" {
  description = "CIDR block you use in your VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of AZs to use for the subnets. We will create a subnet per specified AZ"
  type        = list(string)
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

variable "tags" {
  description = "Optional Tags"
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "Name"
  type        = string
}

variable "route_tables" {
  description = "Route table IDs to attach the subnets to"
  type        = list(string)
}

variable "map_public_ip_on_launch" {
  description = "Specify true to indicate that instances launched into the subnets should be assigned a public IP address"
  type        = bool
  default     = false
}
