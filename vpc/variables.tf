variable "cidr_block" {
  description = "CIDR block you want to have in your VPC"
}

variable "availability_zones" {
  description = "List of AZs to use for the subnets. Defaults to all available AZs when not specified (looped over sequentially for the amount of subnets)"
  type        = list(string)
  default     = null
}

variable "amount_public_nat-bastion_subnets" {
  type        = number
  description = "Amount of subnets you need"
  default     = 1
}

variable "amount_public_lb_subnets" {
  type        = number
  description = "Amount of subnets you need"
  default     = 3
}

variable "amount_private_app_subnets" {
  type        = number
  description = "Amount of subnets you need"
  default     = 3
}

variable "amount_private_db_subnets" {
  type        = number
  description = "Amount of subnets you need"
  default     = 3
}

variable "amount_private_management_subnets" {
  type        = number
  description = "Amount of subnets you need"
  default     = 0
}

variable "name" {
  description = "Main name for your your VPC, subnets, etc."
  default     = "production"
}

variable "number_private_rt" {
  type        = number
  description = "The desired number of private route tables. In case we want one per AZ we can change this value."
  default     = 1
}

variable "netnum_public_lb" {
  description = "First number of subnet to start of for public_lb subnets"
  default     = "10"
}

variable "netnum_private_app" {
  description = "First number of subnet to start of for private_app subnets"
  default     = "20"
}

variable "netnum_private_db" {
  description = "First number of subnet to start of for private_db subnets"
  default     = "30"
}

variable "netnum_private_management" {
  description = "First number of subnet to start of for private_management subnets"
  default     = "200"
}

variable "netnum_public_nat-bastion" {
  description = "First number of subnet to start of for public_nat-bastion subnets"
  default     = "0"
}

variable "tags" {
  type        = map(string)
  description = "Optional Tags"
  default     = {}
}

variable "extra_tags_vpc" {
  type        = map(string)
  description = "VPC extra tags"
  default     = {}
}

variable "extra_tags_public_nat-bastion" {
  type        = map(string)
  description = "Public nat/bastion subnets extra tags"
  default     = {}
}

variable "extra_tags_public_lb" {
  type        = map(string)
  description = "Public load balancer subnets extra tags"
  default     = {}
}

variable "extra_tags_private_app" {
  type        = map(string)
  description = "Private app subnets extra tags"
  default     = {}
}

variable "extra_tags_private_db" {
  type        = map(string)
  description = "Private database subnets extra tags"
  default     = {}
}

variable "extra_tags_private_management" {
  type        = map(string)
  description = "Private management subnets extra tags"
  default     = {}
}
