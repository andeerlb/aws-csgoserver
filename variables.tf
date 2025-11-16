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

variable "image_id" {
  type    = string
  default = "ami-0d7069e98d190f5ce" 
}

variable "ssh_allowed_cidrs" {
  type    = list(string)
  default = []
}

variable "s3_serverfiles_backup" {
  type        = string
  description = "S3 bucket with serverfiles to optimize initial setup time. (it should have a steamcmd serverfiles)"
  default = ""
}

# List of CS2 servers to deploy
# Each server will be an isolated EC2 instance
variable "servers" {
  type = map(object({
    server_name   = string
    gslt_token    = string
    rcon_passwd   = string
    server_passwd = string
    ssh_key_pair  = string
    instance_type = optional(string, "t3a.small")
  }))
  description = "Map of CS2 servers to deploy. Key is used as unique identifier."

}

