#ressource create VPC

resource "aws_vpc" "utc-vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "utc-vpc"
    env  = "dev"
    team = "config management"
  }
}

#ressource create Subnet

resource "aws_subnet" "subnet_public_1" {
  vpc_id            = aws_vpc.utc-vpc.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet_public_2" {
  vpc_id            = aws_vpc.utc-vpc.id
  cidr_block        = "10.10.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "subnet_private_1" {
  vpc_id            = aws_vpc.utc-vpc.id
  cidr_block        = "10.10.3.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet_private_2" {
  vpc_id            = aws_vpc.utc-vpc.id
  cidr_block        = "10.10.4.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "subnet_private_3" {
  vpc_id            = aws_vpc.utc-vpc.id
  cidr_block        = "10.10.5.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet_private_4" {
  vpc_id            = aws_vpc.utc-vpc.id
  cidr_block        = "10.10.6.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "subnet_public_3" {
  vpc_id            = aws_vpc.utc-vpc.id
  cidr_block        = "10.10.7.0/24"
  availability_zone = "us-east-1c"
}

resource "aws_subnet" "subnet_private_5" {
  vpc_id            = aws_vpc.utc-vpc.id
  cidr_block        = "10.10.8.0/24"
  availability_zone = "us-east-1c"
}

resource "aws_subnet" "subnet_private_6" {
  vpc_id            = aws_vpc.utc-vpc.id
  cidr_block        = "10.10.9.0/24"
  availability_zone = "us-east-1c"
}

#ressource create EIP

resource "aws_eip" "nat_eip_1" {
  domain = "vpc"
}

resource "aws_eip" "nat_eip_2" {
  domain = "vpc"
}

#ressource create NAT Gateway

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id     = aws_subnet.subnet_public_1.id
  depends_on    = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id     = aws_subnet.subnet_public_2.id
  depends_on    = [aws_internet_gateway.igw]
}

#ressource create Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.utc-vpc.id
}

#ressource create Route Table

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.utc-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "private_rt_1" {
  vpc_id = aws_vpc.utc-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_1.id
  }
}

resource "aws_route_table" "private_rt_2" {
  vpc_id = aws_vpc.utc-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_2.id
  }
}

#ressource create Route Table Association

resource "aws_route_table_association" "public_rt_assoc_1" {
  subnet_id      = aws_subnet.subnet_public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc_2" {
  subnet_id      = aws_subnet.subnet_public_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt_assoc_1" {
  subnet_id      = aws_subnet.subnet_private_1.id
  route_table_id = aws_route_table.private_rt_1.id
}

resource "aws_route_table_association" "private_rt_assoc_2" {
  subnet_id      = aws_subnet.subnet_private_2.id
  route_table_id = aws_route_table.private_rt_2.id
}

resource "aws_route_table_association" "private_rt_assoc_3" {
  subnet_id      = aws_subnet.subnet_private_3.id
  route_table_id = aws_route_table.private_rt_1.id
}

resource "aws_route_table_association" "private_rt_assoc_4" {
  subnet_id      = aws_subnet.subnet_private_4.id
  route_table_id = aws_route_table.private_rt_2.id
}

resource "aws_route_table_association" "public_rt_assoc_3" {
  subnet_id      = aws_subnet.subnet_public_3.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt_assoc_5" {
  subnet_id      = aws_subnet.subnet_private_5.id
  route_table_id = aws_route_table.private_rt_1.id
}

resource "aws_route_table_association" "private_rt_assoc_6" {
  subnet_id      = aws_subnet.subnet_private_6.id
  route_table_id = aws_route_table.private_rt_1.id
}