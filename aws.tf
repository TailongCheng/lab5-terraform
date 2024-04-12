## Network
## -------------------------
resource "aws_vpc" "aws_my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.name}_vpc"
  }
}

# Public Subnet and association
resource "aws_subnet" "aws_public_subnet_1" {
  vpc_id            = aws_vpc.aws_my_vpc.id
  cidr_block        = var.aws_public_subnet_cidr_1
  availability_zone = var.aws_az_1

  tags = {
    Name = "${var.name}_public_subnet_1"
  }
}

resource "aws_subnet" "aws_public_subnet_2" {
  vpc_id            = aws_vpc.aws_my_vpc.id
  cidr_block        = var.aws_public_subnet_cidr_2
  availability_zone = var.aws_az_2

  tags = {
    Name = "${var.name}_public_subnet_2"
  }
}

resource "aws_internet_gateway" "aws_ig" {
  vpc_id            = aws_vpc.aws_my_vpc.id

  tags = {
    Name = "${var.name}_ig"
  }
}

resource "aws_route_table" "aws_pub_rt" {
  vpc_id            = aws_vpc.aws_my_vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_internet_gateway.aws_ig.id
  }

  tags = {
    Name = "${var.name}_pub_rt"
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

# Private Subnet and association
resource "aws_subnet" "aws_private_subnet_1" {
  vpc_id            = aws_vpc.aws_my_vpc.id
  cidr_block        = var.aws_private_subnet_cidr_1
  availability_zone = var.aws_az_1

  tags = {
    Name = "${var.name}_private_subnet_1"
  }
}

resource "aws_subnet" "aws_private_subnet_2" {
  vpc_id            = aws_vpc.aws_my_vpc.id
  cidr_block        = var.aws_private_subnet_cidr_2
  availability_zone = var.aws_az_2

  tags = {
    Name = "${var.name}_private_subnet_2"
  }
}

resource "aws_route_table" "aws_pri_rt1" {
  vpc_id            = aws_vpc.aws_my_vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_nat_gateway.aws_nat_gw1.id
  }

  tags = {
    Name = "${var.name}_pub_rt"
  }
}

resource "aws_route_table" "aws_pri_rt_2" {
  vpc_id            = aws_vpc.aws_my_vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_nat_gateway.aws_ig.id
  }

  tags = {
    Name = "${var.name}_pub_rt"
  }
}

# NAT Gateway # Can be comment out
resource "aws_eip" "aws_nat_eip_1" {
  vpc = true

  tags = {
    Name = "${var.name}_nat_eip_1"
  }
}

resource "aws_eip" "aws_nat_eip_2" {
  vpc = true

  tags = {
    Name = "${var.name}_nat_eip_2"
  }
}

resource "aws_nat_gateway" "aws_nat_gw_1" {
  allocation_id = aws_eip.aws_nat_eip.id
  subnet_id     = aws_subnet.aws_public_subnet_1.id
  depends_on    = [aws_internet_gateway.aws_ig]

  tags = {
    Name = "${var.name}_nat_gw_1"
  }
}

resource "aws_nat_gateway" "aws_nat_gw_2" {
  allocation_id = aws_eip.aws_nat_eip.id
  subnet_id     = aws_subnet.aws_public_subnet_2.id
  depends_on    = [aws_internet_gateway.aws_ig]

  tags = {
    Name = "${var.name}_nat_gw_2"
  }
}

# Security Group
resource "aws_security_group" "aws_sg" {
  name              = "BastionHostSG"
  description       = "Allow SSH"
  vpc_id            = aws_vpc.aws_my_vpc.id

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
