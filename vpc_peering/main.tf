terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [
        aws.source,
        aws.target,
      ]
    }
  }
}

data "aws_vpc" "source" {
  provider = aws.source
  id       = var.source_vpc_id
}

data "aws_vpc" "target" {
  provider = aws.target
  id       = var.target_vpc_id
}
