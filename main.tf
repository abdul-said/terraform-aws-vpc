resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block_vpc
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.internet_gateway_name
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = var.public_subnet_1_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[1]
  cidr_block        = var.public_subnet_2_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_2"
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

resource "aws_route_table_association" "public_rt_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_rt_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = var.private_subnet_1_cidr
  map_public_ip_on_launch = false

  tags = {
    Name = "private_subnet_1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[1]
  cidr_block        = var.private_subnet_2_cidr
  map_public_ip_on_launch = false

  tags = {
    Name = "private_subnet_2"
  }
}

resource "aws_subnet" "private_db_subnet_1" {
  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = var.private_db_subnet_1_cidr
  map_public_ip_on_launch = false


  tags = {
    Name = "private_db_subnet_1"
  }
}

resource "aws_subnet" "private_db_subnet_2" {
  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[1]
  cidr_block        = var.private_db_subnet_2_cidr
  map_public_ip_on_launch = false

  tags = {
    Name = "private_db_subnet_2"
  }
}

resource "aws_nat_gateway" "gw_1" {
  subnet_id         = aws_subnet.public_subnet_1.id
  connectivity_type = "private"

  tags = {
    Name = "gw NAT 1"
  }
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.default_cidr
    gateway_id = aws_nat_gateway.gw_1.id
  }

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private_rt_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private.id

}

resource "aws_route_table_association" "private_rt_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db_rt_1" {
  subnet_id      = aws_subnet.private_db_subnet_1.id
  route_table_id = aws_route_table.private.id

}

resource "aws_route_table_association" "private_db_rt_2" {
  subnet_id      = aws_subnet.private_db_subnet_2.id
  route_table_id = aws_route_table.private.id
}
