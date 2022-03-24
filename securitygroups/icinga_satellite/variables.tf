variable "vpc_id" {
  description = "ID of the VPC where to deploy in"
}

variable "name" {
  description = "The name"
}

variable "icinga_master_ip" {
  description = "IP of the Icinga master, in CIDR/32 notation"
}

variable "internal_sg_id" {
  description = "The Icinga satellite will be able to access this security group through NRPE, if provided."
  default     = ""
}
