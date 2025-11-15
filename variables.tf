variable "default_tags" {
  type = map(string)
  default = {
    Terraform = "yes"
  }
}

variable "azs" {
  type    = list(string)
  default = ["sa-east-1a"]
}

variable "ssh_key_pair" {
  type    = string
  default = ""
}

variable "server_name" {
  type    = string
}

variable "rcon_passwd" {
  type    = string
}

variable "image_id" {
  type    = string
  default = "ami-09b9b17384f68fd7c"
}

variable "prefix_name" {
  type    = string
  default = ""
}

variable "gslt_token" {
  type    = string
}