variable "vpc_id" {
  description = "ID of the VPC where to deploy in"
}

variable "name" {
  description = "The name"
}

variable "puppet_master_ip" {
  description = "IP of the Puppet master, in CIDR/32 notation"
}
