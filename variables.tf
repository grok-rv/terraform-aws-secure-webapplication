variable "aws_region" {
  description = "specify the aws cloud region"
  default = "us-west-2"
}

variable "env" {
  description = "specify the environment. eg: test or prod"
  default     = "dev"
}

variable "projectname" {
  description = "assign a project name for the s3 bucket to append"
}
variable "accessIp" {
  description = "pass the cidr block for bastion host restricting access to your Mypublic ip or vpn ip or allow it from 0.0.0.0/0 if wanted to open for all"
}
variable "cidrblock" {
  description = "this is the cidr block for vpc to be created. example \"10.123.0.0/16\""
}

variable "cidr_public" {
  type = list
  description = "this is the cidr block for public subnet list: example [\"10.123.1.0/24\", \"10.123.2.0/24\"]"
}

variable "cidr_private" {
  type = list
  description = "this is the cidr block for private subnet list: example [\"10.123.3.0/24\", \"10.123.4.0/24\"]"
}
variable "counts" {
  description = "count of the resources to be spin up"
}
variable "instancetype" {
  description = "instance type to be used for privatge ec2 instance: default \"t2.micro\""
}
variable "keyname" {
  description = "keyname to be used for ssh access to bastion and private ec2 instances. example \"tfs-key\""
}
variable "publickeypath" {
  description = "the file path location to your pub key to be passed on to ec2 instances. example \"/home/username/.ssh/id_rsa.pub\""
}


