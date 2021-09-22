variable "default_tags" {
  type = map(string)
  default = {
    Terraform = "yes"
  }
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "name" {
  type = string
}

variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "azs" {
  type = list(string)
}

variable "database_subnets" {
  type = list(string)
  default = []
}

variable "private_subnets" {
    type = list(string)
    default = []
}

variable "public_subnets" {
    type = list(string)
    default = []
}

variable "enable_nat_gateway" {
    type = bool
    default = false
}

variable "enable_vpn_gateway" {
    type = bool
    default = false
}

variable "enable_dns_hostnames" {
    type = bool
    default = true
}

variable "enable_dns_support" {
    type = bool
    default = true
}