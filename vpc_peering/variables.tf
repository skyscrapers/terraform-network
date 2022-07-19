variable "target_account_id" {
  type        = string
  description = "AWS account id of the target VPC"
}

variable "target_vpc_id" {
  type        = string
  description = "ID of the target VPC"
}

variable "target_name" {
  type        = string
  description = "Name of the target VPC"
}

variable "target_route_table_ids" {
  type        = list(string)
  description = "List of route table IDs from the target VPC that should be routable to the source VPC"
}

variable "source_vpc_id" {
  type        = string
  description = "ID of the source VPC"
}

variable "source_name" {
  type        = string
  description = "Name of the source VPC"
}

variable "source_route_table_ids" {
  type        = list(string)
  description = "List of route table IDs from the source VPC that should be routable to the target VPC"
}

variable "tags" {
  type        = map(string)
  description = "AWS tags to apply to the created resources"
  default     = {}
}
