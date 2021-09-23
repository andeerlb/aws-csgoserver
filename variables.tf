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
    default = "DosAmigos"
}

variable "rcon_passwd" {
    type = string
    default = "FlL1EA7v6QZh"
}

variable "image_id" {
    type = string
    default = "ami-09b9b17384f68fd7c"
}

variable "prefix_name" {
    type = string
    default = "csgoserver"
}

variable "gslt_token" {
    type = string
    default = "13D2E94677FC1C3859AF60FAFBE17234"
}

variable "bucket_s3_backup_name" {
    type = string
    default = ""
}