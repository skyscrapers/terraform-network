# terraform-network

Terraform modules networking related vpc,subnets,route tables..

> [!IMPORTANT]
> These modules are originally designed to be used within Skyscrapers and are tailored mostly to our own needs. They may also be suitable for your own use cases, however in general we recommend using the excellent [terraform-aws-vpc](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest) module instead.

- [terraform-network](#terraform-network)
  - [vpc](#vpc)
    - [Requirements](#requirements)
    - [Providers](#providers)
    - [Modules](#modules)
    - [Resources](#resources)
    - [Inputs](#inputs)
    - [Outputs](#outputs)
    - [Example](#example)
  - [vpc\_peering](#vpc_peering)
    - [Requirements](#requirements-1)
    - [Providers](#providers-1)
    - [Modules](#modules-1)
    - [Resources](#resources-1)
    - [Inputs](#inputs-1)
    - [Outputs](#outputs-1)
  - [Breaking changes and migration](#breaking-changes-and-migration)
    - [From v5 to v6](#from-v5-to-v6)
    - [From v4 to v5](#from-v4-to-v5)
    - [From v2 to v3](#from-v2-to-v3)

## vpc

This module will create a vpc with the option to specify several types of subnets:

- public_lb_subnets
- private_app_subnets
- private_db_subnets
- private_management_subnets

It will also create the required NAT Gateways (in separate public_nat subnets) and route tables for the private subnets. There's option for either a single NAT gateway or one per Availability Zone (default). The private_app and private_db subnets are private subnets.

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
| <a name="module_public_nat_subnets"></a> [public_nat_subnets](#module_public_nat_subnets) | ../subnets | n/a |

### Resources

| Name | Type |
|------|------|
| [aws_eip.nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_block"></a> [cidr_block](#input_cidr_block) | CIDR block you want to have in your VPC | `any` | n/a | yes |
| <a name="input_amount_private_app_subnets"></a> [amount_private_app_subnets](#input_amount_private_app_subnets) | Amount of subnets you need | `number` | `3` | no |
| <a name="input_amount_private_db_subnets"></a> [amount_private_db_subnets](#input_amount_private_db_subnets) | Amount of subnets you need | `number` | `3` | no |
| <a name="input_amount_private_management_subnets"></a> [amount_private_management_subnets](#input_amount_private_management_subnets) | Amount of subnets you need | `number` | `0` | no |
| <a name="input_amount_public_lb_subnets"></a> [amount_public_lb_subnets](#input_amount_public_lb_subnets) | Amount of subnets you need | `number` | `3` | no |
| <a name="input_availability_zones"></a> [availability_zones](#input_availability_zones) | List of AZs to use for the subnets. Defaults to all available AZs when not specified (looped over sequentially for the amount of subnets) | `list(string)` | `null` | no |
| <a name="input_enable_nat_gateway"></a> [enable_nat_gateway](#input_enable_nat_gateway) | Whether to deploy NAT Gateways | `bool` | `true` | no |
| <a name="input_extra_tags_private_app"></a> [extra_tags_private_app](#input_extra_tags_private_app) | Private app subnets extra tags | `map(string)` | `{}` | no |
| <a name="input_extra_tags_private_db"></a> [extra_tags_private_db](#input_extra_tags_private_db) | Private database subnets extra tags | `map(string)` | `{}` | no |
| <a name="input_extra_tags_private_management"></a> [extra_tags_private_management](#input_extra_tags_private_management) | Private management subnets extra tags | `map(string)` | `{}` | no |
| <a name="input_extra_tags_public_lb"></a> [extra_tags_public_lb](#input_extra_tags_public_lb) | Public load balancer subnets extra tags | `map(string)` | `{}` | no |
| <a name="input_extra_tags_public_nat"></a> [extra_tags_public_nat](#input_extra_tags_public_nat) | Public nat subnets extra tags | `map(string)` | `{}` | no |
| <a name="input_extra_tags_vpc"></a> [extra_tags_vpc](#input_extra_tags_vpc) | VPC extra tags | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input_name) | Main name for your your VPC, subnets, etc. | `string` | `"production"` | no |
| <a name="input_netnum_private_app"></a> [netnum_private_app](#input_netnum_private_app) | First number of subnet to start of for private_app subnets | `string` | `"20"` | no |
| <a name="input_netnum_private_db"></a> [netnum_private_db](#input_netnum_private_db) | First number of subnet to start of for private_db subnets | `string` | `"30"` | no |
| <a name="input_netnum_private_management"></a> [netnum_private_management](#input_netnum_private_management) | First number of subnet to start of for private_management subnets | `string` | `"200"` | no |
| <a name="input_netnum_public_lb"></a> [netnum_public_lb](#input_netnum_public_lb) | First number of subnet to start of for public_lb subnets | `string` | `"10"` | no |
| <a name="input_netnum_public_nat"></a> [netnum_public_nat](#input_netnum_public_nat) | First number of subnet to start of for public_nat subnets | `string` | `"0"` | no |
| <a name="input_single_nat_gateway"></a> [single_nat_gateway](#input_single_nat_gateway) | Whether to use a single NAT Gateway or one per enabled Availability Zone. The number of NAT Gateways also determines the number of private route tables created | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input_tags) | Optional Tags | `map(string)` | `{}` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_network_acl_id"></a> [default_network_acl_id](#output_default_network_acl_id) | Id of the default network acl |
| <a name="output_nat_gateway_ids"></a> [nat_gateway_ids](#output_nat_gateway_ids) | n/a |
| <a name="output_nat_gateway_ips"></a> [nat_gateway_ips](#output_nat_gateway_ips) | n/a |
| <a name="output_private_app_subnets"></a> [private_app_subnets](#output_private_app_subnets) | List of the private_app subnets id created |
| <a name="output_private_db_subnets"></a> [private_db_subnets](#output_private_db_subnets) | List of the private_db subnets id created |
| <a name="output_private_management_subnets"></a> [private_management_subnets](#output_private_management_subnets) | List of the private_management subnets id created |
| <a name="output_private_rts"></a> [private_rts](#output_private_rts) | List of the ids of the private route tables created |
| <a name="output_public_lb_subnets"></a> [public_lb_subnets](#output_public_lb_subnets) | List of the public_lb subnets id created |
| <a name="output_public_nat_subnets"></a> [public_nat_subnets](#output_public_nat_subnets) | List of the public_nat subnets id created |
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

## Breaking changes and migration

### From v5 to v6

In v6 of this module we have:

1. removed the `securitygroups` submodules and removed the nat_gateway module
2. integrated creation of NAT gateways into the main `vpc` module itself
3. renamed the `public_nat-bastion` subnets to `public_nat` subnets
4. make sure subnet associations are correctly matched to route tables, and NAT gateways, per availability zone

These changes are breaking, you need to update variables, and can cause network disruption due to subnet re-assosication to their respective route tables.

Related to this change, we have simplified the inputs for the `vpc` module.

Removed vars:

- `amount_public_nat_bastion_subnets`: this will be determind by the amount of NAT Gateways to deploy
- `number_private_rt`: this will be determind by the amount of NAT Gateways to deploy
- `number_nat_gateways`: this is now controlled by the new `enable_nat_gateway` and `single_nat_gateway` variables

New vars:

- `enable_nat_gateway` (default: true): Whether to deploy NAT Gateways or not
- `single_nat_gateway` (default: false): Whether to deploy a single NAT Gateway or one per AZ

Remaned:

- `netnum_public_nat-bastion` -> `netnum_public_nat`

If you deployed the `vpc` and `nat_gateway` modules separately, you will need to remove the `nat_gateway` module from your code and update the `vpc` module to use the new `*_nat_gateway` variables. You can use `moved` blocks to migrate the NAT Gateway resources to the new `vpc` module:

```hcl
moved {
  from = module.nat_gateway.aws_eip.nat_gateway
  to   = module.vpc.aws_eip.nat_gateway
}

moved {
  from = module.nat_gateway.aws_nat_gateway.gateway
  to   = module.vpc.aws_nat_gateway.gateway
}

moved {
  from = module.nat_gateway.aws_route.r
  to   = module.vpc.aws_route.private
}
```

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
