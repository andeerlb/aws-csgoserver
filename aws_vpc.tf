module "vpc_csgo" {
  source = "./modules/vpc"

  name = "csgo"
  azs  = var.azs
  cidr = "10.0.0.0/16"
  public_subnets = ["10.0.101.0/24"]
}