provider "aws" {
}



resource "aws_instance" "myec2" {
  ami = "ami-01dc883c13e87eeda"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.main.id
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  key_name = "FortiAWSKey"
  tags = {
        Environment = "terraform-course"
  }
}

resource "aws_eip" "lb" {
  vpc      = true
  tags = {
    Environment = "terraform-course"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.myec2.id
  allocation_id = aws_eip.lb.id
}


resource "aws_security_group" "allow_tls" {
  name        = "kplabs-security-group"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.lb.public_ip}/32"]

#    cidr_blocks = [aws_eip.lb.public_ip/32]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

#    cidr_blocks = [aws_eip.lb.public_ip/32]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

    tags = {
    Environment = "terraform-course"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Environment = "terraform-course"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  

  tags = {
    Environment = "terraform-course"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Environment = "terraform-course"
  }

}

resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.main.id
route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Environment = "terraform-course"
  }
}

resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rtb_public.id
}