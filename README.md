# terraform-network
Terraform modules networking related vpc,subnets,route tables..

## Nat Gateway
Creates a nat gateway and automatically adds a route table to the route tables passed as parameter

### Available variables:
 * [`private_route_tables`]: List(required): List of private route tables that require the nat gateway [NOTE the number of nat gateways should match the number of private routes]
 * [`number_nat_gateways`]: String(optional):  Number of nat gateways required
 * [`public_subnets`]: List(required): The subnets where we are going to create/deploy the NAT gateways
### Output
 * [`ids`]: List: The ids of the nat gateways created.

### Example
  ```
  module "nat_gateway" {
    source = "nat_gateway"
    private_route_tables="${module.vpc.private_rts}"
    public_lb_subnets="${module.vpc.public_lb_subnets}"
  }
  ```
## Subnets

Creates a number of subnets and divides them in different parts based on the input params

### Available variables:
 * [`cidr`]: String(required): the CIDR to be divided into subnets  
 * [`newbits`]: String(optional): default to 8. For details see https://www.terraform.io/docs/configuration/interpolation.html#cidrsubnet_iprange_newbits_netnum_
 * [`netnum`]: String(optional): default to 0. First number of subnet to start of (ex I want a 10.1,10.2,10.3 subnet I specify 1)
 * [`vpc_id`]: String(required): the VPC ID where we want to create the subnets
 * [`name`]: String(required): the name of the subnets
 * [`tag`]: String(optional): optional subnet tag
 * [`project`]: String(required): the name of the project these subnets belong to
 * [`environment`]: String(required): the name of the environment these subnets belong to (prod,stag,dev)
 * [`num_subnets`]: String(optional): default to 3. the number of subnets we want to create

### Output
 * [`ids`]: List: the ids of the subnets created

### Example
```
module "public_lb_subnets" {
  source             = "../subnets"
  num_subnets        = "${var.amount_public_lb_subnets}"
  name               = "public_lb"
  cidr               = "${var.cidr_block}"
  netnum             = 0
  vpc_id             = "${aws_vpc.main.id}"
  aws_region         = "${var.aws_region}"
  environment        = "${var.environment}"
  project            = "${var.project}"
}
```
## vpc
This module will create a vpc with the option to specify 3 types of subnets:
 - public_nat-bastion_subnets
 - public_lb_subnets
 - private_app_subnets
 - private_db_subnets

It will also create the required route tables for the private subnets. The private_app and private_db subnets are private subnets.

### Available variables:
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

### Output:
 * [`vpc_id`]: String: the id of the vpc created
 * [`public_nat-bastion`]: List: list of the public_nat-bastion subnets id created
 * [`public_lb_subnets`]: List: list of the public_lb subnets id created
 * [`private_app_subnets`]: List: list of the private_app subnets id created
 * [`private_db_subnets`]: List: list of the private_db subnets id created
 * [`base_sg`]: String: id of the security group created
 * [`private_rts`]:  List: list of the ids of the private route tables created

### Example
 ```
 module "vpc" {
   source = "vpc"
   cidr_block = "172.16.0.0/16"
   project = "test"
   environment = "prod"

 }
 ```
