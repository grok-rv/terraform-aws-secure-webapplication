#-----------Provider AWS --------------------
provider "aws" {
  region                  = var.aws_region
  //shared_credentials_file = "~/.aws/credentials"
  role_arn                = "arn:aws:iam::041470850105:role/aws-jenkins"
  profile                 = var.env
  version                 = "~> 2.0"
}

#####################################################
#----Terraforom backend s3----------------------------
/*
terraform {
  backend "s3" {
      shared_credentials_file = "~/.aws/credentials"
      profile                 = "dev"
      bucket                  = "aws-secure-web-app-state"
      key                     = "dev/backup-state/terraform.tfstate"
      region                  = "us-west-2"
      dynamodb_table          = "aws-secure-web-app-state"
      encrypt                 = true
  }
}
*/

####################################################
#---------module storage for s3, dynamodb------------------------

module "storage" {
  source = "./storage"
}
###################################################
#--------mdouel networking for vpc,subnets,routes,IG,nat-GW------------

module "network" {
  source = "./networking"
  cidrblock = var.cidrblock
  accessIp = var.accessIp
  cidr_public = var.cidr_public
  cidr_private = var.cidr_private
}
#######################################################
#------module instances----------------------------

module "instance" {
  source = "./instance"
  keyname = var.keyname
  publickeypath = var.publickeypath
  bastion-sg = module.network.bastion-sg
  ec2-sg = module.network.ec2-sg
  instancetype = var.instancetype
  counts = var.counts
  private-subnets = module.network.private_subnet
  public-subnet = module.network.public_Subnet
}
###################################################################
#-----module-load-balancers-------------------------------------
module "loadbalancer" {
  source = "./a-loadbalancer"
  alb-sg = module.network.alb-sg
  pub-subnet = module.network.public_Subnet
  vpc-id = module.network.vpc-id
  target-id = [ module.instance.ec2instance_id ]
}
