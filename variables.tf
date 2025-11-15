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
  default = "watercooler"
}

variable "ssh_allowed_cidrs" {
  type    = list(string)
  default = ["161.22.57.32/32"]
}

variable "rcon_passwd" {
  type    = string
  default = "123456"
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
  default = "62A650B8FBDC792C344DAB28CBC19425"
}