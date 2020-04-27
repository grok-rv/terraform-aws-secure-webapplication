variable "aws_region" {
  description = "specify the aws cloud region"
  default = "us-west-2"
}

variable "env" {
  description = "specify the environment. eg: test or prod"
  default     = "la"
}

variable "role_acc" {
  description = "role account"
  default     = "843653485881"
}

variable "accessIp" {
  default = "0.0.0.0/0"
  description = "pass the cidr block for bastion host restricting access to your Mypublic ip or vpn ip or allow it from 0.0.0.0/0 if wanted to open for all"
}
variable "cidrblock" {
  default = "10.123.0.0/16"
  description = "this is the cidr block for vpc to be created. example \"10.123.0.0/16\""
}

variable "cidr_public" {
  type = list
  default = ["10.123.1.0/24","10.123.2.0/24"]
  description = "this is the cidr block for public subnet list: example [\"10.123.1.0/24\", \"10.123.2.0/24\"]"
}

variable "cidr_private" {
  type = list
  default = ["10.123.3.0/24","10.123.4.0/24"]
  description = "this is the cidr block for private subnet list: example [\"10.123.3.0/24\", \"10.123.4.0/24\"]"
}
variable "counts" {
  default = "2"
  description = "count of the resources to be spin up"
}
variable "instancetype" {
  default = "t2.micro"
  description = "instance type to be used for privatge ec2 instance: default \"t2.micro\""
}
variable "keyname" {
  default = "tfs-key"
  description = "keyname to be used for ssh access to bastion and private ec2 instances. example \"tfs-key\""
}
variable "publickeypath" {
  default = "/home/ramu/.ssh/id_rsa.pub"
  description = "the file path location to your pub key to be passed on to ec2 instances. example \"/home/username/.ssh/id_rsa.pub\""
}


