variable "cidr_block" {
  description = "CIDR block you want to have in your VPC"
}

variable "amount_public_nat-bastion_subnets" {
  description = "Amount of subnets you need"
  default     = "1"
}

variable "amount_public_lb_subnets" {
  description = "Amount of subnets you need"
  default     = "3"
}

variable "amount_private_app_subnets" {
  description = "Amount of subnets you need"
  default     = "3"
}

variable "amount_private_db_subnets" {
  description = "Amount of subnets you need"
  default     = "3"
}

variable "amount_private_management_subnets" {
  description = "Amount of subnets you need"
  default     = "0"
}

variable "environment" {
  description = "How do you want to call your environment, this is helpful if you have more than 1 VPC."
  default     = "production"
}

variable "project" {
  description = "The current project"
}

variable "number_private_rt" {
  description = "The desired number of private route tables. In case we want one per AZ we can change this value."
  default     = "1"
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
  type        = "map"
  description = "Optional Tags"
  default     = {}
}

variable "extra_tags_vpc" {
  type        = "map"
  description = "VPC extra tags"
  default     = {}
}

variable "extra_tags_public_nat-bastion" {
  type        = "map"
  description = "Public nat/bastion subnets extra tags"
  default     = {}
}

variable "extra_tags_public_lb" {
  type        = "map"
  description = "Public load balancer subnets extra tags"
  default     = {}
}

variable "extra_tags_private_app" {
  type        = "map"
  description = "Private app subnets extra tags"
  default     = {}
}

variable "extra_tags_private_db" {
  type        = "map"
  description = "Private database subnets extra tags"
  default     = {}
}

variable "extra_tags_private_management" {
  type        = "map"
  description = "Private management subnets extra tags"
  default     = {}
}
