provider "aws" {
}
module "storage" {
  source = "./storage"
  projectname = var.projectname
}

module "network" {
  source = "./networking"
  cidrblock = var.cidrblock
  accessIp = var.accessIp
  cidr_public = var.cidr_public 
  cidr_private = var.cidr_private
}

module "instance" {
  source = "./instance"
  keyname = var.keyname
  publickeypath = var.publickeypath
  bastion-sg = "${module.network.bastion-sg}"
  ec2-sg = "${module.network.ec2-sg}"
  instancetype = var.instancetype
  counts = var.counts
  private-subnets = "${module.network.private_subnet}"   
  public-subnet = "${module.network.public_Subnet}"
}
module "loadbalancer" {
  source = "./a-loadbalancer"
  alb-sg = "${module.network.alb-sg}"
  pub-subnet = "${module.network.public_Subnet}"
  vpc-id = "${module.network.vpc-id}"
  target-id = [ "${module.instance.ec2instance_id}" ]
}
