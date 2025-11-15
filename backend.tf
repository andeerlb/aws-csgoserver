terraform {
  backend "s3" {
    bucket = "wt-terraform-state"
    key    = "cs2server/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "sa-east-1"
}