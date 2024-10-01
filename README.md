# terraform-network

Terraform modules networking related vpc,subnets,route tables..

- [terraform-network](#terraform-network)
  - [Nat Gateway](#nat-gateway)
    - [Requirements](#requirements)
    - [Providers](#providers)
    - [Modules](#modules)
    - [Resources](#resources)
    - [Inputs](#inputs)
    - [Outputs](#outputs)
    - [Example](#example)
  - [Subnets](#subnets)
  - [Requirements](#requirements-1)
  - [Providers](#providers-1)
  - [Modules](#modules-1)
  - [Resources](#resources-1)
  - [Inputs](#inputs-1)
  - [Outputs](#outputs-1)
    - [Example](#example-1)
  - [vpc](#vpc)
    - [Requirements](#requirements-2)
    - [Providers](#providers-2)
    - [Modules](#modules-2)
    - [Resources](#resources-2)
    - [Inputs](#inputs-2)
    - [Outputs](#outputs-2)
    - [Example](#example-2)
  - [vpc\_peering](#vpc_peering)
    - [Requirements](#requirements-3)
    - [Providers](#providers-3)
    - [Modules](#modules-3)
    - [Resources](#resources-3)
    - [Inputs](#inputs-3)
    - [Outputs](#outputs-3)
  - [securitygroups/all](#securitygroupsall)
    - [Example](#example-3)
  - [securitygroups/icinga\_satellite](#securitygroupsicinga_satellite)
    - [Example](#example-4)
  - [securitygroups/puppet](#securitygroupspuppet)
    - [Example](#example-5)
  - [securitygroups/web\_public](#securitygroupsweb_public)
    - [Example](#example-6)
  - [Migration](#migration)
    - [From v4 to v5](#from-v4-to-v5)
    - [From v2 to v3](#from-v2-to-v3)

## Nat Gateway

Creates a nat gateway and automatically adds a route table to the route tables passed as parameter

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.12 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider_aws) | n/a |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [aws_eip.nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_nat_gateway.gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.r](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_subnet.ngw_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_private_route_tables"></a> [private_route_tables](#input_private_route_tables) | n/a | `list(string)` | n/a | yes |
| <a name="input_public_subnets"></a> [public_subnets](#input_public_subnets) | n/a | `list(string)` | n/a | yes |
| <a name="input_number_nat_gateways"></a> [number_nat_gateways](#input_number_nat_gateways) | n/a | `number` | `1` | no |
| <a name="input_tags"></a> [tags](#input_tags) | Optional extra tags | `map(string)` | `{}` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_ids"></a> [ids](#output_ids) | n/a |
| <a name="output_ips"></a> [ips](#output_ips) | n/a |

### Example

```hcl
module "nat_gateway" {
  source               = "nat_gateway"
  private_route_tables = module.vpc.private_rts
  public_subnets       = module.vpc.public_subnets
}
```

## Subnets

Creates a number of subnets and divides them in different parts based on the input params

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route_table_association.subnet_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr"></a> [cidr](#input_cidr) | CIDR block you use in your VPC | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input_name) | Name | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id) | ID of the VPC where we want to deploy the subnet | `string` | n/a | yes |
| <a name="input_availability_zones"></a> [availability_zones](#input_availability_zones) | List of AZs to use for the subnets. Defaults to all available AZs when not specified (looped over sequentially for the amount of subnets) | `list(string)` | `null` | no |
| <a name="input_map_public_ip_on_launch"></a> [map_public_ip_on_launch](#input_map_public_ip_on_launch) | Specify true to indicate that instances launched into the subnets should be assigned a public IP address | `bool` | `false` | no |
| <a name="input_netnum"></a> [netnum](#input_netnum) | Netnum to use for generating the EKS worker subnets. For more information, see the [cidrsubnet function docs](https://www.terraform.io/docs/configuration/functions/cidrsubnet.html) | `number` | `0` | no |
| <a name="input_newbits"></a> [newbits](#input_newbits) | Newbits to use for generating the subnets. For more information, see the [cidrsubnet function docs](https://www.terraform.io/docs/configuration/functions/cidrsubnet.html) | `number` | `8` | no |
| <a name="input_num_route_tables"></a> [num_route_tables](#input_num_route_tables) | Amount of route tables to attach the subnets to | `number` | `0` | no |
| <a name="input_num_subnets"></a> [num_subnets](#input_num_subnets) | Amount of subnets to create | `number` | `3` | no |
| <a name="input_route_tables"></a> [route_tables](#input_route_tables) | Route tables to attach the subnets to | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input_tags) | Optional Tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ids"></a> [ids](#output_ids) | n/a |

### Example

```hcl
module "public_lb_subnets" {
  source      = "../subnets"
  name        = "test-public-lb"
  num_subnets = var.amount_public_lb_subnets
  visibility  = "public"
  role        = "lb"
  cidr        = var.cidr_block
  netnum      = 0
  vpc_id      = aws_vpc.main.id
  aws_region  = var.aws_region

  tags = {
    visibility        = "public"
    role              = "lb"
    KubernetesCluster = "test"
  }
}
```

## vpc

This module will create a vpc with the option to specify 4 types of subnets:

* public_nat-bastion_subnets
* public_lb_subnets
* private_app_subnets
* private_db_subnets

It will also create the required route tables for the private subnets. The private_app and private_db subnets are private subnets.

### Requirements

No requirements.

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider_aws) | n/a |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_private_app_subnets"></a> [private_app_subnets](#module_private_app_subnets) | ../subnets | n/a |
| <a name="module_private_db_subnets"></a> [private_db_subnets](#module_private_db_subnets) | ../subnets | n/a |
| <a name="module_private_management_subnets"></a> [private_management_subnets](#module_private_management_subnets) | ../subnets | n/a |
| <a name="module_public_lb_subnets"></a> [public_lb_subnets](#module_public_lb_subnets) | ../subnets | n/a |
| <a name="module_public_nat-bastion_subnets"></a> [public_nat-bastion_subnets](#module_public_nat-bastion_subnets) | ../subnets | n/a |

### Resources

| Name | Type |
|------|------|
| [aws_internet_gateway.gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_route.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_block"></a> [cidr_block](#input_cidr_block) | CIDR block you want to have in your VPC | `any` | n/a | yes |
| <a name="input_amount_private_app_subnets"></a> [amount_private_app_subnets](#input_amount_private_app_subnets) | Amount of subnets you need | `number` | `3` | no |
| <a name="input_amount_private_db_subnets"></a> [amount_private_db_subnets](#input_amount_private_db_subnets) | Amount of subnets you need | `number` | `3` | no |
| <a name="input_amount_private_management_subnets"></a> [amount_private_management_subnets](#input_amount_private_management_subnets) | Amount of subnets you need | `number` | `0` | no |
| <a name="input_amount_public_lb_subnets"></a> [amount_public_lb_subnets](#input_amount_public_lb_subnets) | Amount of subnets you need | `number` | `3` | no |
| <a name="input_amount_public_nat-bastion_subnets"></a> [amount_public_nat-bastion_subnets](#input_amount_public_nat-bastion_subnets) | Amount of subnets you need | `number` | `1` | no |
| <a name="input_availability_zones"></a> [availability_zones](#input_availability_zones) | List of AZs to use for the subnets. Defaults to all available AZs when not specified (looped over sequentially for the amount of subnets) | `list(string)` | `null` | no |
| <a name="input_extra_tags_private_app"></a> [extra_tags_private_app](#input_extra_tags_private_app) | Private app subnets extra tags | `map(string)` | `{}` | no |
| <a name="input_extra_tags_private_db"></a> [extra_tags_private_db](#input_extra_tags_private_db) | Private database subnets extra tags | `map(string)` | `{}` | no |
| <a name="input_extra_tags_private_management"></a> [extra_tags_private_management](#input_extra_tags_private_management) | Private management subnets extra tags | `map(string)` | `{}` | no |
| <a name="input_extra_tags_public_lb"></a> [extra_tags_public_lb](#input_extra_tags_public_lb) | Public load balancer subnets extra tags | `map(string)` | `{}` | no |
| <a name="input_extra_tags_public_nat-bastion"></a> [extra_tags_public_nat-bastion](#input_extra_tags_public_nat-bastion) | Public nat/bastion subnets extra tags | `map(string)` | `{}` | no |
| <a name="input_extra_tags_vpc"></a> [extra_tags_vpc](#input_extra_tags_vpc) | VPC extra tags | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input_name) | Main name for your your VPC, subnets, etc. | `string` | `"production"` | no |
| <a name="input_netnum_private_app"></a> [netnum_private_app](#input_netnum_private_app) | First number of subnet to start of for private_app subnets | `string` | `"20"` | no |
| <a name="input_netnum_private_db"></a> [netnum_private_db](#input_netnum_private_db) | First number of subnet to start of for private_db subnets | `string` | `"30"` | no |
| <a name="input_netnum_private_management"></a> [netnum_private_management](#input_netnum_private_management) | First number of subnet to start of for private_management subnets | `string` | `"200"` | no |
| <a name="input_netnum_public_lb"></a> [netnum_public_lb](#input_netnum_public_lb) | First number of subnet to start of for public_lb subnets | `string` | `"10"` | no |
| <a name="input_netnum_public_nat-bastion"></a> [netnum_public_nat-bastion](#input_netnum_public_nat-bastion) | First number of subnet to start of for public_nat-bastion subnets | `string` | `"0"` | no |
| <a name="input_number_private_rt"></a> [number_private_rt](#input_number_private_rt) | The desired number of private route tables. In case we want one per AZ we can change this value. | `number` | `1` | no |
| <a name="input_tags"></a> [tags](#input_tags) | Optional Tags | `map(string)` | `{}` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_network_acl_id"></a> [default_network_acl_id](#output_default_network_acl_id) | Id of the default network acl |
| <a name="output_private_app_subnets"></a> [private_app_subnets](#output_private_app_subnets) | List of the private_app subnets id created |
| <a name="output_private_db_subnets"></a> [private_db_subnets](#output_private_db_subnets) | List of the private_db subnets id created |
| <a name="output_private_management_subnets"></a> [private_management_subnets](#output_private_management_subnets) | List of the private_management subnets id created |
| <a name="output_private_rts"></a> [private_rts](#output_private_rts) | List of the ids of the private route tables created |
| <a name="output_public_lb_subnets"></a> [public_lb_subnets](#output_public_lb_subnets) | List of the public_lb subnets id created |
| <a name="output_public_nat-bastion"></a> [public_nat-bastion](#output_public_nat-bastion) | List of the public_nat-bastion subnets id created |
| <a name="output_public_rts"></a> [public_rts](#output_public_rts) | List of the ids of the public route tables created |
| <a name="output_vpc_id"></a> [vpc_id](#output_vpc_id) | The id of the vpc created |

### Example

```hcl
module "vpc" {
  source     = "vpc"
  cidr_block = "172.16.0.0/16"
  name       = "test"
  tags       = { "KubernetesCluster" = "test" }
}
```

## vpc_peering

Module to create a VPC peering connection between two VPCs. It creates the needed resources on both ends of the peering connection, thus it requires two different AWS providers.

It also creates the routing between the two VPCs if the route tables are provided.

### Requirements

No requirements.

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.source"></a> [aws.source](#provider_aws.source) | n/a |
| <a name="provider_aws.target"></a> [aws.target](#provider_aws.target) | n/a |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [aws_route.source_to_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.target_to_source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_vpc_peering_connection.peering](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection_accepter.peering](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_vpc_peering_connection_options.peering_accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_vpc_peering_connection_options.peering_requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_vpc.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_source_name"></a> [source_name](#input_source_name) | Name of the source VPC | `string` | n/a | yes |
| <a name="input_source_route_table_ids"></a> [source_route_table_ids](#input_source_route_table_ids) | List of route table IDs from the source VPC that should be routable to the target VPC | `list(string)` | n/a | yes |
| <a name="input_source_vpc_id"></a> [source_vpc_id](#input_source_vpc_id) | ID of the source VPC | `string` | n/a | yes |
| <a name="input_target_account_id"></a> [target_account_id](#input_target_account_id) | AWS account id of the target VPC | `string` | n/a | yes |
| <a name="input_target_name"></a> [target_name](#input_target_name) | Name of the target VPC | `string` | n/a | yes |
| <a name="input_target_route_table_ids"></a> [target_route_table_ids](#input_target_route_table_ids) | List of route table IDs from the target VPC that should be routable to the source VPC | `list(string)` | n/a | yes |
| <a name="input_target_vpc_id"></a> [target_vpc_id](#input_target_vpc_id) | ID of the target VPC | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input_tags) | AWS tags to apply to the created resources | `map(string)` | `{}` | no |
| <a name="input_target_region"></a> [target_region](#input_target_region) | AWS region of the target VPC (optional) | `string` | `null` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_peering_id"></a> [vpc_peering_id](#output_vpc_peering_id) | ID of the VPC peering connection |

## securitygroups/all

This module creates and exposes a reusable security group called `sg-all`.

The implementation uses the separate `aws_security_group` and `aws_security_group_rule` resources
to make the creation and adaptation of security groups much more modular.

### Example

```hcl
module "securitygroup_all" {
  source = "github.com/skyscrapers/terraform-network//securitygroups/all"
  vpc_id = module.vpc.vpc_id
  name   = "sg_all"
}
```

## securitygroups/icinga_satellite

This module creates and exposes a reusable security group called `sg_icinga_satellite`, expanded
with project and environment info.

The implementation uses the separate `aws_security_group` and `aws_security_group_rule` resources
to make the creation and adaptation of security groups much more modular.

### Example

```hcl
module "securitygroup_icinga" {
  source           = "github.com/skyscrapers/terraform-network//securitygroups/icinga_satellite"
  vpc_id           = module.vpc.vpc_id
  name             = "sg_icinga_satellite"
  icinga_master_ip = "123.234.123.234/32"
}
```

## securitygroups/puppet

This module creates and exposes a reusable security group called `sg_puppet`, expanded
with project and environment info.

The implementation uses the separate `aws_security_group` and `aws_security_group_rule` resources
to make the creation and adaptation of security groups much more modular.

### Example

```hcl
module "securitygroup_icinga" {
  source           = "github.com/skyscrapers/terraform-network//securitygroups/puppet"
  vpc_id           = module.vpc.vpc_id
  name             = "sg_puppet"
  puppet_master_ip = "123.234.123.234/32"
}
```

## securitygroups/web_public

This module creates and exposes a reusable security group called `sg_web_public`, expanded
with project and environment info.

The implementation uses the separate `aws_security_group` and `aws_security_group_rule` resources
to make the creation and adaptation of security groups much more modular.

### Example

```hcl
module "securitygroup_web_public" {
  source = "github.com/skyscrapers/terraform-network//securitygroups/web_public"
  vpc_id = module.vpc.vpc_id
  name   = "sg_web_public"
}
```

## Migration

### From v4 to v5

Starting with v5, we've changed how naming and tagging of resources happen within the modules. In earlier versions, a resource's name was derived from the `project` and `environment` variables.

Starting with v5, we only provide a `name` variable, so make sure to update your code accordingly. In most cases this shouldn't be a breaking change: names for VPCs, subnets, route tables etc can be changed without a destroy/recreate of the resources.

**Important**: The exception is for Security Groups, so eg. in case of the `securitygroups/all` module, you should specify `name = "sg_all_myproject_myenv"` to keep the old name.

We've also removed our default, hardcoded tags for `Project` and `Environment`. You can still re-add these via the respective `tags` variables, or [use the `default_tags` parameter from the AWS provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags).

### From v2 to v3

The Terraform state migration commands to migrate from VPC module v2.x to v3.0 and up.

```hcl
terraform state mv module.vpc.aws_route_table_association.public_nat-bastion_hosts module.vpc.module.public_nat-bastion_subnets.aws_route_table_association.subnet_association
terraform state mv module.vpc.aws_route_table_association.private_app[0] module.vpc.module.private_app_subnets.aws_route_table_association.subnet_association[0]
terraform state mv module.vpc.aws_route_table_association.private_app[1] module.vpc.module.private_app_subnets.aws_route_table_association.subnet_association[1]
terraform state mv module.vpc.aws_route_table_association.private_app[2] module.vpc.module.private_app_subnets.aws_route_table_association.subnet_association[2]
terraform state mv module.vpc.aws_route_table_association.private_management[0] module.vpc.module.private_management_subnets.aws_route_table_association.subnet_association[0]
terraform state mv module.vpc.aws_route_table_association.private_management[1] module.vpc.module.private_management_subnets.aws_route_table_association.subnet_association[1]
terraform state mv module.vpc.aws_route_table_association.private_management[2] module.vpc.module.private_management_subnets.aws_route_table_association.subnet_association[2]
terraform state mv module.vpc.aws_route_table_association.public_lb_hosts[0] module.vpc.module.public_lb_subnets.aws_route_table_association.subnet_association[0]
terraform state mv module.vpc.aws_route_table_association.public_lb_hosts[1] module.vpc.module.public_lb_subnets.aws_route_table_association.subnet_association[1]
terraform state mv module.vpc.aws_route_table_association.public_lb_hosts[2] module.vpc.module.public_lb_subnets.aws_route_table_association.subnet_association[2]
terraform state mv module.vpc.aws_route_table_association.private_db[0] module.vpc.module.private_db_subnets.aws_route_table_association.subnet_association[0]
terraform state mv module.vpc.aws_route_table_association.private_db[1] module.vpc.module.private_db_subnets.aws_route_table_association.subnet_association[1]
terraform state mv module.vpc.aws_route_table_association.private_db[2] module.vpc.module.private_db_subnets.aws_route_table_association.subnet_association[2]
```
