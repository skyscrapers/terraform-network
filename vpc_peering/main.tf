provider "aws" {
  alias = "source"
}

provider "aws" {
  alias = "target"
}

data "aws_vpc" "source" {
  provider = aws.source
  id       = var.source_vpc_id
}

data "aws_vpc" "target" {
  provider = aws.target
  id       = var.target_vpc_id
}
