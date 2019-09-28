variable "projectname" {}
variable "accessIp" {}
variable "cidrblock" {}
variable "cidr_public" {
  type = list
}
variable "cidr_private" {
  type = list
}
variable "counts" {}
variable "instancetype" {}
variable "keyname" {}
variable "publickeypath" {}
#variable "bastion-sg" {}
#variable "ec2-sg" {}
/*variable "private-subnets" {
  type = list
}
variable "public-subnet" {
  type = list
}
*/
