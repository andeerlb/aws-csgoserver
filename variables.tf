variable "default_tags" {
    type = map(string)
    default = {
        Terraform = "yes"
    }
}

variable "azs" {
    type = list(string)
    default = ["sa-east-1a"]
}

variable "ssh_key_pair" {
    type = string
    default = "csgoserver"
}

variable "server_name" {
    type = string
    default = "Dos@Amigos"
}

variable "rcon_passwd" {
    type = string
    default = "FlL1EA7v6QZh"
}

variable "image_id" {
    type = string
    default = "ami-09b9b17384f68fd7c"
}