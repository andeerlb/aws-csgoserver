terraform {
  backend "s3" {
    bucket = "babinskitfstate"
    key    = "csgoserver/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "sa-east-1"
}