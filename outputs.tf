output "private_subnet" {
  value = aws_subnet.private_subnet
}

output "public_subnet" {
  value = aws_subnet.public_subnet
}

/*output "subnet_ids" {
  value = {for k, v in aws_subnet.subnets : k => v.id}
  description = "outputs all subnet id's"
}

output "private_subnet_ids" {
  value = aws_subnet.subnets[private_1].id
  description = "outputs all subnet id's"
}*/