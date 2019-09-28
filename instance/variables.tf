variable "keyname" {}
variable "publickeypath" {}
variable "counts" {}
variable "instancetype" {}
variable "public-subnet" {
  type = list
}
variable "private-subnets" {
  type = list
}
variable "bastion-sg" {}
variable "ec2-sg" {}
