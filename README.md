# terraform-network

Terraform modules networking related vpc,subnets,route tables..

## Nat Gateway

Creates a nat gateway and automatically adds a route table to the route tables passed as parameter

### Available variables

* [`private_route_tables`]: List(required): List of private route tables that require the nat gateway [NOTE the number of nat gateways should match the number of private routes]
* [`number_nat_gateways`]: String(optional):  Number of nat gateways required
* [`public_subnets`]: List(required): The subnets where we are going to create/deploy the NAT gateways

### Output

* [`ids`]: List: The ids of the nat gateways created.

### Example

```hcl
module "nat_gateway" {
  source = "nat_gateway"
  private_route_tables="${module.vpc.private_rts}"
  public_subnets="${module.vpc.public_subnets}"
}
```

## Subnets

Creates a number of subnets and divides them in different parts based on the input params

### Available variables

* [`cidr`]: String(required): the CIDR to be divided into subnets  
* [`newbits`]: String(optional): default to 8. For details see https://www.terraform.io/docs/configuration/interpolation.html#cidrsubnet_iprange_newbits_netnum_
* [`netnum`]: String(optional): default to 0. First number of subnet to start of (ex I want a 10.1,10.2,10.3 subnet I specify 1)
* [`vpc_id`]: String(required): the VPC ID where we want to create the subnets
* [`role`]: String(required): the role of the subnets. Example values are `lb`, `db` and `app`.
* [`visibility`]: String(required): the visibility of the subnets. Valid values are `public` and `private`
* [`tags`]: Map(optional): optional tags
* [`project`]: String(required): the name of the project these subnets belong to
* [`environment`]: String(required): the name of the environment these subnets belong to (prod,stag,dev)
* [`num_subnets`]: String(optional): default to 3. the number of subnets we want to create
* [`route_tables`]: List(optional): the list of route tables to associate to the created subnet. This will associate the route table to the created subnet sequentially. If the subnet number is greater than the number of route tables, the route table will be selected sing a standard mod algorithm
* [`num_route_tables`]: String(optional): default to 0. the number of route tables passed in route_tables. NOTE: this is due to a bug in terraform that cannot iterate over count param

### Output

* [`ids`]: List: the ids of the subnets created

### Example

```hcl
module "public_lb_subnets" {
  source             = "../subnets"
  num_subnets        = "${var.amount_public_lb_subnets}"
  visibility         = "public"
  role               = "lb"
  cidr               = "${var.cidr_block}"
  netnum             = 0
  vpc_id             = "${aws_vpc.main.id}"
  aws_region         = "${var.aws_region}"
  environment        = "${var.environment}"
  project            = "${var.project}"
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

### Available variables

* [`cidr_block`]: String(required): the CIDR of the new VPC
* [`amount_public_nat-bastion_subnets`]: String(optional): default to 3. the amount of public_nat-bastion subnets required
* [`amount_public_lb_subnets`]: String(optional): default to 3. the amount of public_lb subnets required
* [`amount_private_app_subnets`]: String(optional): default to 3. the amount of private_app subnets required
* [`amount_private_db_subnets`]: String(optional): default to 3. the amount of private_db subnets required
* [`environment`]: String(required): the name of the environment these subnets belong to (prod,stag,dev)
* [`project`]: String(required): the name of the project these subnets belong to
* [`number_private_rt`]: String(optional): default to 1. the desired number of private route tables. In case we want one per AZ we can change this value.
* [`netnum_public_nat-bastion`]: String(optional): default to 0. First number of subnet to start of for public_nat-bastion subnets
* [`netnum_public_lb`]: String(optional): default to 10. First number of subnet to start of for public_lb subnets
* [`netnum_private_app`]: String(optional): default to 20. First number of subnet to start of for private_app subnets
* [`netnum_private_db`]: String(optional): default to 30. First number of subnet to start of for private_db subnets
* [`tags`]: Map(optional): optional tags

### Output

* [`vpc_id`]: String: the id of the vpc created
* [`public_nat-bastion`]: List: list of the public_nat-bastion subnets id created
* [`public_lb_subnets`]: List: list of the public_lb subnets id created
* [`private_app_subnets`]: List: list of the private_app subnets id created
* [`private_db_subnets`]: List: list of the private_db subnets id created
* [`base_sg`]: String: id of the security group created
* [`private_rts`]:  List: list of the ids of the private route tables created

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
  vpc_id                           = "${module.vpc.vpc_id}"
  project                          = "${var.project}"
  environment                      = "${var.environment}"
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
  vpc_id                           = "${module.vpc.vpc_id}"
  project                          = "${var.project}"
  environment                      = "${var.environment}"
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
  vpc_id                           = "${module.vpc.vpc_id}"
  project                          = "${var.project}"
  environment                      = "${var.environment}"
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
  vpc_id                           = "${module.vpc.vpc_id}"
  project                          = "${var.project}"
  environment                      = "${var.environment}"
}
```
