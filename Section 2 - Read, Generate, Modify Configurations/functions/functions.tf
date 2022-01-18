provider "aws" {

}

locals {
  time = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
}

variable "region" {
  default = "ap-southeast-2"
}

variable "tags" {
  type = list
  default = ["firstec2","secondec2"]
}

variable "ami" {
  type = map
  default = {
    "us-east-1" = "ami-0323c3dd2da7fb37d"
    "us-west-2" = "ami-0d6621c01e8c2de2c"
    "ap-southeast-2" = "ami-01dc883c13e87eeda"
  }
}

resource "aws_key_pair" "loginkey" {
  key_name   = "login-key"
  public_key = file("${path.module}/terraformkey.pub")
}

resource "aws_instance" "app-dev" {
   ami = lookup(var.ami,var.region)
   instance_type = "t2.micro"
   key_name = aws_key_pair.loginkey.key_name
   count = 2

   tags = {
     Name = element(var.tags,count.index)
   }
}


output "timestamp" {
  value = local.time
}