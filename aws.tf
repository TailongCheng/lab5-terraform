## Network
## -------------------------
resource "aws_vpc" "cheng_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "cheng_vpc"
  }
}

resource "aws_subnet" "aws_public_subnet_1" {
  vpc_id            = aws_vpc.cheng_vpc.id
  cidr_block        = var.aws_public_subnet_cidr_1
  availability_zone = var.aws_az_1

  tags = {
    Name = "cheng_public_subnet_1"
  }
}

resource "aws_subnet" "aws_public_subnet_2" {
  vpc_id            = aws_vpc.cheng_vpc.id
  cidr_block        = var.aws_public_subnet_cidr_2
  availability_zone = var.aws_az_2

  tags = {
    Name = "cheng_public_subnet_2"
  }
}

resource "aws_subnet" "aws_private_subnet_1" {
  vpc_id            = aws_vpc.cheng_vpc.id
  cidr_block        = var.aws_private_subnet_cidr_1
  availability_zone = var.aws_az_1

  tags = {
    Name = "Cheng_private_subnet_1"
  }
}

resource "aws_subnet" "aws_private_subnet_2" {
  vpc_id            = aws_vpc.cheng_vpc.id
  cidr_block        = var.aws_private_subnet_cidr_2
  availability_zone = var.aws_az_2

  tags = {
    Name = "Cheng_private_subnet_2"
  }
}

resource "aws_internet_gateway" "cheng_ig" {
  vpc_id            = aws_vpc.cheng_vpc.id

  tags = {
    Name = "cheng_ig"
  }
}

resource "aws_route_table" "aws_pub_rt" {
  vpc_id            = aws_vpc.cheng_vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_internet_gateway.cheng_ig.id
  }

  tags = {
    Name = "cheng_pub_rt"
  }
}

resource "aws_route_table_association" "aws_pub_sub_assoc_1" {
  subnet_id         = aws_subnet.aws_public_subnet_1.id
  route_table_id    = aws_route_table.aws_pub_rt.id
}

resource "aws_route_table_association" "aws_pub_sub_assoc_2" {
  subnet_id         = aws_subnet.aws_public_subnet_2.id
  route_table_id    = aws_route_table.aws_pub_rt.id
}

resource "aws_security_group" "aws_sg" {
  name              = "BastionHostSG"
  description       = "Allow SSH"
  vpc_id            = aws_vpc.cheng_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-051f8a213df8bc089"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.aws_public_subnet_1.id

  security_groups = [aws_security_group.aws_sg.id]

  tags = {
    Name = "ExampleAppServerInstance"
  }
}