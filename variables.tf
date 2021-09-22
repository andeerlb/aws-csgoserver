variable "default_tags" {
    type = map(string)
    default = {
        Terraform = "yes"
    }
}

variable "azs" {
    type = list(string)
    default = ["us-east-1a"]
}