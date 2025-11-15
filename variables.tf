variable "default_tags" {
  type = map(string)
  default = {
    Terraform = "yes"
  }
}

variable "azs" {
  type    = list(string)
  default = ["sa-east-1a"] # São Paulo Availability Zone A
}

variable "ssh_key_pair" {
  type    = string
  default = ""
}

variable "server_name" {
  type    = string
  default = ""
}

variable "ssh_allowed_cidrs" {
  type    = list(string)
  default = []
}

variable "rcon_passwd" {
  type    = string
  default = ""
}

variable "image_id" {
  type    = string
  default = "ami-0d7069e98d190f5ce" 
}

variable "prefix_name" {
  type    = string
  default = ""
}

variable "gslt_token" {
  type    = string
  default = ""
}