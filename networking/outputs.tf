output "public_Subnet" {
  value = aws_subnet.tfs_public-subnet.*.id
}
output "private_subnet" {
  value = aws_subnet.tfs_private-subnet.*.id
}
output "bastion-sg" {
 value = aws_security_group.bastion-sg.id
}
output "ec2-sg" {
  value = aws_security_group.ec2-sg.id
}
output "public_Subnet_ip" {
  value = aws_subnet.tfs_public-subnet.*.cidr_block

}
output "alb-sg" {
  value = aws_security_group.alb-sg.id
}
output "vpc-id" {
  value = aws_vpc.tfs_vpc.id
}

output "igw-id" {
  value = aws_internet_gateway.tfs_ig.id
}
output "nat-gw" {
  value = aws_nat_gateway.nat-gw.public_ip
}
