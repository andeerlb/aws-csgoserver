# Shared VPC across all CS2 servers
# This VPC is created once and shared by all workspaces
module "vpc_cs2" {
  source = "./modules/vpc"

  name           = "cs2-shared-network"
  azs            = var.azs
  cidr           = "10.0.0.0/16"
  public_subnets = ["10.0.101.0/24"]
}