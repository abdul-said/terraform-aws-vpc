resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block_vpc
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "subnets" {
    for_each = var.subnets
    vpc_id = aws_vpc.main.id
    availability_zone = each.value.availability_zone
    cidr_block = each.value.cidr_block

    tags = {
    Name = each.key
  }
}
    
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.internet_gateway_name
  }
}
