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
  default = "wtpoc-keypair"
}

variable "server_name" {
  type    = string
}

variable "ssh_allowed_cidrs" {
  type    = list(string)
  default = ["161.22.57.32/32"]
}

variable "rcon_passwd" {
  type    = string
}

variable "image_id" {
  type    = string
  default = "ami-0d7069e98d190f5ce" 
}

variable "gslt_token" {
  type    = string
}