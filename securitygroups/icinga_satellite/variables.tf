variable "vpc_id" {
  description = "ID of the VPC where to deploy in"
}

variable "environment" {
  description = "How do you want to call your environment, this is helpful if you have more than 1 VPC."
  default     = "production"
}

variable "project" {
  description = "The current project"
}

variable "icinga_master_ip" {
  description = "IP of the Icinga master, in CIDR/32 notation"
}

variable "internal_sg_id" {
  description = "The Icinga satellite will be able to access this security group through NRPE, if provided."
  default     = ""
}

