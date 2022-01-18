terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
}

resource "aws_instance" "myec2" {
    ami = "ami-01dc883c13e87eeda" 
    instance_type = "t2.micro"
    subnet_id = aws_subnet.main.id
  
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Production"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Production"
  }
}

