# terraform-network

Terraform modules networking related vpc,subnets,route tables..

## Nat Gateway

Creates a nat gateway and automatically adds a route table to the route tables passed as parameter

### Available variables

* [`private_route_tables`]: List(string)(required): List of private route tables that require the nat gateway [NOTE the number of nat gateways should match the number of private routes]
* [`number_nat_gateways`]: Number(optional):  Number of nat gateways required
* [`public_subnets`]: List(string)(required): The subnets where we are going to create/deploy the NAT gateways
* [`tags`]: Map(optional): optional tags

### Output

* [`ids`]: List: The ids of the nat gateways created.

### Example

```hcl
module "nat_gateway" {
  source = "nat_gateway"
  private_route_tables=module.vpc.private_rts
  public_subnets=module.vpc.public_subnets
}
```

## Subnets

Creates a number of subnets and divides them in different parts based on the input params

### Inputs

**TODO** once terraform-docs properly supports 0.12...

### Outputs

| Name | Description |
|------|-------------|
| ids  | the ids of the subnets created |

### Example

```hcl
module "public_lb_subnets" {
  source             = "../subnets"
  num_subnets        = var.amount_public_lb_subnets
  visibility         = "public"
  role               = "lb"
  cidr               = var.cidr_block
  netnum             = 0
  vpc_id             = aws_vpc.main.id
  aws_region         = var.aws_region
  environment        = var.environment
  project            = var.project
  tags               = { "KubernetesCluster" = "test" }
}
```

## vpc

This module will create a vpc with the option to specify 4 types of subnets:

* public_nat-bastion_subnets
* public_lb_subnets
* private_app_subnets
* private_db_subnets

It will also create the required route tables for the private subnets. The private_app and private_db subnets are private subnets.

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| availability\_zones | List of AZs to use for the subnets. Defaults to all available AZs when not specified (looped over sequentially for the amount of subnets) | list(string) | `null` | no |
| amount\_private\_app\_subnets | Amount of subnets you need | number | `3` | no |
| amount\_private\_db\_subnets | Amount of subnets you need | number | `3` | no |
| amount\_private\_management\_subnets | Amount of subnets you need | number | `0` | no |
| amount\_public\_lb\_subnets | Amount of subnets you need | number | `3` | no |
| amount\_public\_nat-bastion\_subnets | Amount of subnets you need | number | `1` | no |
| cidr\_block | CIDR block you want to have in your VPC | string | n/a | yes |
| environment | How do you want to call your environment, this is helpful if you have more than 1 VPC. | string | `"production"` | no |
| extra\_tags\_private\_app | Private app subnets extra tags | map | `<map>` | no |
| extra\_tags\_private\_db | Private database subnets extra tags | map | `<map>` | no |
| extra\_tags\_private\_management | Private management subnets extra tags | map | `<map>` | no |
| extra\_tags\_public\_lb | Public load balancer subnets extra tags | map | `<map>` | no |
| extra\_tags\_public\_nat-bastion | Public nat/bastion subnets extra tags | map | `<map>` | no |
| extra\_tags\_vpc | VPC extra tags | map | `<map>` | no |
| netnum\_private\_app | First number of subnet to start of for private_app subnets | string | `"20"` | no |
| netnum\_private\_db | First number of subnet to start of for private_db subnets | string | `"30"` | no |
| netnum\_private\_management | First number of subnet to start of for private_management subnets | string | `"200"` | no |
| netnum\_public\_lb | First number of subnet to start of for public_lb subnets | string | `"10"` | no |
| netnum\_public\_nat-bastion | First number of subnet to start of for public_nat-bastion subnets | string | `"0"` | no |
| number\_private\_rt | The desired number of private route tables. In case we want one per AZ we can change this value. | number | `1` | no |
| project | The current project | string | n/a | yes |
| tags | Optional Tags | map | `<map>` | no |

### Outputs

| Name | Description |
|------|-------------|
| default\_network\_acl\_id | Id of the default network acl |
| private\_app\_subnets | List of the private_app subnets id created |
| private\_db\_subnets | List of the private_db subnets id created |
| private\_management\_subnets | List of the private_management subnets id created |
| private\_rts | List of the ids of the private route tables created |
| public\_lb\_subnets | List of the public_lb subnets id created |
| public\_nat-bastion | List of the public_nat-bastion subnets id created |
| public\_rts | List of the ids of the public route tables created |
| vpc\_id | The id of the vpc created |

### Example

```hcl
module "vpc" {
  source      = "vpc"
  cidr_block  = "172.16.0.0/16"
  project     = "test"
  environment = "prod"
  tags        = { "KubernetesCluster" = "test" }
}
```

### Migration

#### From v2 to v3

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

## securitygroups/all

This module creates and exposes a reusable security group called `sg-all`.

The implementation uses the separate `aws_security_group` and `aws_security_group_rule` resources
to make the creation and adaptation of security groups much more modular.

### Available variables:

* [`vpc_id`]: String(required): the id of the VPC where the security group must be created
* [`project`]: String(required): the name of the customer or project
* [`environment`]: String(required): the environment to create the security group in. Examples: `staging`, `production`

### Output

* [`sg_id`]: String: the id of the security group created

### Example

```hcl
module "securitygroup_all" {
  source                           = "github.com/skyscrapers/terraform-network//securitygroups/all"
  vpc_id                           = module.vpc.vpc_id
  project                          = var.project
  environment                      = var.environment
}
```

## securitygroups/icinga_satellite

This module creates and exposes a reusable security group called `sg_icinga_satellite`, expanded
with project and environment info.

The implementation uses the separate `aws_security_group` and `aws_security_group_rule` resources
to make the creation and adaptation of security groups much more modular.

### Available variables

* [`vpc_id`]: String(required): the id of the VPC where the security group must be created
* [`project`]: String(required): the name of the customer or project
* [`environment`]: String(required): the environment to create the security group in. Examples: `staging`, `production`
* [`icinga_master_ip`]: String(required): the IP address of the Icinga master in CIDR notation.
* [`internal_sg_id`]: String(optional): The Icinga satellite will be able to access this security group through NRPE, if provided.

### Output

* [`sg_id`]: String: the id of the security group created

### Example

```hcl
module "securitygroup_icinga" {
  source                           = "github.com/skyscrapers/terraform-network//securitygroups/icinga_satellite"
  vpc_id                           = module.vpc.vpc_id
  project                          = var.project
  environment                      = var.environment
  icinga_master_ip                 = "123.234.123.234/32"
}
```

## securitygroups/puppet

This module creates and exposes a reusable security group called `sg_puppet`, expanded
with project and environment info.

The implementation uses the separate `aws_security_group` and `aws_security_group_rule` resources
to make the creation and adaptation of security groups much more modular.

### Available variables

* [`vpc_id`]: String(required): the id of the VPC where the security group must be created
* [`project`]: String(required): the name of the customer or project
* [`environment`]: String(required): the environment to create the security group in. Examples: `staging`, `production`
* [`puppet_master_ip`]: String(required): the IP address of the Puppet master in CIDR notation.

### Output:

* [`sg_id`]: String: the id of the security group created

### Example

```hcl
module "securitygroup_icinga" {
  source                           = "github.com/skyscrapers/terraform-network//securitygroups/puppet"
  vpc_id                           = module.vpc.vpc_id
  project                          = var.project
  environment                      = var.environment
  puppet_master_ip                 = "123.234.123.234/32"
}
```

## securitygroups/web_public

This module creates and exposes a reusable security group called `sg_web_public`, expanded
with project and environment info.

The implementation uses the separate `aws_security_group` and `aws_security_group_rule` resources
to make the creation and adaptation of security groups much more modular.

### Available variables

* [`vpc_id`]: String(required): the id of the VPC where the security group must be created
* [`project`]: String(required): the name of the customer or project
* [`environment`]: String(required): the environment to create the security group in. Examples: `staging`, `production`

### Output

* [`sg_id`]: String: the id of the security group created

### Example

```hcl
module "securitygroup_web_public" {
  source                           = "github.com/skyscrapers/terraform-network//securitygroups/web_public"
  vpc_id                           = module.vpc.vpc_id
  project                          = var.project
  environment                      = var.environment
}
```
