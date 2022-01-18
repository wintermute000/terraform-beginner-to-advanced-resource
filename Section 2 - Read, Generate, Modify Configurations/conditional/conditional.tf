provider "aws" {
}

variable "istest" {}


resource "aws_instance" "dev" {
   ami = "ami-01dc883c13e87eeda"
   instance_type = "t2.micro"
   count = var.istest == true ? 3 : 0
   tags = { name = "dev-${count.index}" } 

}

resource "aws_instance" "prod" {
   ami = "ami-01dc883c13e87eeda"
   instance_type = "t2.large"
   count = var.istest == false ? 1 : 0
   tags = { name = "prod" } 
}