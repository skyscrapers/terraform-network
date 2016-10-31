# securitygroups terraform module
This module creates and exposes reusable security groups.

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
