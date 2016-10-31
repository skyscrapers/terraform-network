# securitygroups terraform module
This module creates and exposes reusable security groups.

The implementation uses the separate `aws_security_group` and `aws_security_group_rule` resources
to make the creation and adaptation of security groups much more modular.

The security groups here should be reusable for all setups on one hand and customisable per setup
on the other hand. 

The `sg_all` security group is a good example for this: the reusable part with 
outgoing `ntp` and `https` access is in this module, but by exposing the security group, 
a very specfic TF customer module can extend `sg_all`
with a rule to allow traffic for customer specific setup, e.g. Datadog.

## Generated resources
- security groups:
  * `sg_all`: Security group that needs to be attached to all instances

## Required variables

### vpc_id
String: ID of the VPC where to deploy the security groups in.

### project
String: The current project

## Optional variables

### environment
String: How do you want to call your environment, this is helpful if you have more than 1 VPC.

## Outputs

### sg_all_id
String: Security group that needs to be added to every instances

## Example

```
module "securitygroups" {
  source                           = "../../../modules/securitygroups"
  vpc_id                           = "${module.vpc.vpc_id}"
  project                          = "${var.project}"
  environment                      = "${var.environment}"
}
```
