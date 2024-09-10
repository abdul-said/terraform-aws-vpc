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

resource "aws_route_table_association" "a" {
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
  domain   = "vpc"
}

resource "aws_security_group" "public_sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = var.allow_http_public
  ip_protocol       = "tcp"
  to_port           = var.allow_http_public
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = var.allow_https_public
  ip_protocol       = "tcp"
  to_port           = var.allow_https_public
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.default_cidr
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "private_sg" {
  name        = "allow_tls"
  description = "Allow public subnet inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_subnet_traffic"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = var.private_subnet_cidr
  from_port         = var.allow_http_public
  ip_protocol       = "tcp"
  to_port           = var.allow_http_public
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.private_subnet_cidr
  from_port         = var.allow_https_public
  ip_protocol       = "tcp"
  to_port           = var.allow_https_public
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.default_cidr
  ip_protocol       = "-1" # semantically equivalent to all ports
}