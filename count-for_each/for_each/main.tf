variable "ami_id" {
    description = "passing values to ami_id"
    default = ""
    type = string
}

variable "instance_type" {
    description = "passing vales to instance_type"
    default = ""
    type = string
}

variable "env" {
    description = "environment name"
    default = ["dev","test","prod"]
    type = list(string)
}

resource "aws_instance" "name" {
    ami = var.ami_id
    instance_type = var.instance_type
    for_each = toset(var.env)  #here toset is used to convert list to set bacause for_each only accepts map and set not list
    tags = {
      name = each.key   # here we are creating 3 instances with different names
    }
    }
  
