module "vpc_cs2" {
  source = "./modules/vpc"

  name           = "cs2network"
  azs            = var.azs
  cidr           = "10.0.0.0/16"
  public_subnets = ["10.0.101.0/24"]
}