resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block_vpc
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.main.id
    availability_zone = data.aws_availability_zones.available.names[0]
    cidr_block = var.public_subnet_cidr

    tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.main.id
    availability_zone = data.aws_availability_zones.available.names[0]
    cidr_block = var.private_subnet_cidr

    tags = {
    Name = "private_subnet"
  }
}
    
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.internet_gateway_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.default_cidr
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_rt" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_nat_gateway" "example" {
  subnet_id     = aws_subnet.private_subnet.id 
  allocation_id = aws_eip.lb.id

  tags = {
    Name = "gw NAT"
  }
}

resource "aws_eip" "lb" {
  domain   = var.eip-domain
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.default_cidr
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private_rt" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private.id
}
