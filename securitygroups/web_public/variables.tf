variable "vpc_id" {
  description = "ID of the VPC where to deploy in"
}

variable "environment" {
  description = "How do you want to call your environment, this is helpful if you have more than 1 VPC."
}

variable "project" {
  description = "The current project"
}
