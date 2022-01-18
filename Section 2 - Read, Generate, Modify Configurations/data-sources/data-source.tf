provider "aws" {
}

data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["aws-marketplace"]


  filter {
    name   = "name"
    values = ["*ubuntu-focal-20.04-amd64-server*"]
  }
}

resource "aws_instance" "instance-1" {
  ami           = data.aws_ami.app_ami.id
  instance_type = "t2.micro"
}