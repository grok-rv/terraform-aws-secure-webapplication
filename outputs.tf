output "S3_bucketname" {
  value = module.storage.terraformbucket
}

output "dynamodb_table" {
  value = module.storage.terraform-dynamodb
}

output "publicsubnet" {
  value = module.network.public_Subnet

}
output "privatesubnets" {
  value = module.network.private_subnet
}
output "ec2_keypair" {
  value = module.instance.keypair
}
output "ec2-private_vm_ips" {
  value = module.instance.ec2instance-ip
}
output "a-loadbalancer-dnsname" {
  value = module.loadbalancer.alb-dns
}
output "bastion_vm-sg" {
  value = module.network.bastion-sg
}
output "loadbalancer-secgroup" {
  value = module.network.alb-sg
}
output "ec2-private_vm-securitygroup" {
  value = module.network.ec2-sg
}
output "vpc-id" {
  value = module.network.vpc-id
}
output "bastionhost-publicip" {
  value = module.instance.bastionhost
}
output "natgateway-publicip" {
  value = module.network.nat-gw
}
output "internetgateway-id" {
  value = module.network.igw-id
}


