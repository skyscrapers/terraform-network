variable "cidr_block" {
  description = "CIDR block you want to have in your VPC"
}

variable "amount_public_subnets" {
  description = "Amount of subnets you need"
  default     = "3"
}

variable "amount_app_subnets" {
  description = "Amount of subnets you need"
  default     = "3"
}

variable "amount_db_subnets" {
  description = "Amount of subnets you need"
  default     = "3"
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
