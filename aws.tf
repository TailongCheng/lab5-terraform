## Network
## -------------------------
resource "aws_vpc" "cheng_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "cheng_vpc"
  }
}

resource "aws_subnet" "aws_public_subnets" {
  count             = length(var.aws_public_subnet_cidrs)
  vpc_id            = aws_vpc.cheng_vpc.id
  cidr_block        = element(var.aws_public_subnet_cidrs, count.index)
  availability_zone = element(var.aws_azs, count.index)

  tags = {
    Name = "cheng_public_subnet $(count.index + 1)"
  }
}

resource "aws_subnet" "aws_private_subnets" {
  count             = length(var.aws_private_subnet_cidrs)
  vpc_id            = aws_vpc.cheng_vpc.id
  cidr_block        = element(var.aws_private_subnet_cidrs, count.index)
  availability_zone = element(var.aws_azs, count.index)

  tags = {
    Name = "Cheng_private_subnet $(count.index + 1)"
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

resource "aws_route_table_association" "aws_pub_sub_assoc" {
  count             = length(var.aws_public_subnet_cidrs)
  subnet_id         = element(aws_subnet.aws_public_subnets[*].id, count.index)
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
  subnet_id     = aws_subnet.aws_public_subnets.ids[0]

  security_groups = aws_security_group.aws_sg.id

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

