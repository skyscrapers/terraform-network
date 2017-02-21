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
  default = "1"
}
variable "netnum_public_lb" {
  default = "10"
}
variable "netnum_private_app" {
  default = "20"
}
variable "netnum_private_db" {
  default = "30"
}
variable "netnum_private_management" {
  default = "200"
}
variable "netnum_public_nat-bastion" {
  default = "0"
}
