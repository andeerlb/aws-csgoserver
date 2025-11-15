locals {
  # Each server gets a unique name based on server_name variable
  # VPC and SG are shared, only EC2 instances are unique per workspace
  name_with_prefix = "cs2server_${var.server_name}"
}