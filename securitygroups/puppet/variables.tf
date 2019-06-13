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

variable "puppet_master_ip" {
  description = "IP of the Puppet master, in CIDR/32 notation"
}

