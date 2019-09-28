#-------------------------------module/instance/main.tf---------------------

#--------------------fetch az and amazon ami -----------------------------------------
data "aws_availability_zones" "list_az" {
}

data "aws_ami" "ami" {
  most_recent = true
  owners = ["amazon"]
  filter  {
    name = "name"
    values = ["amzn-ami-hvm*-x86_64-gp2"]
  }

}

#-----------------------create a keypair for ssh login to ec2 instances----------------------------
resource "aws_key_pair" "keypair" {
  key_name = var.keyname
  public_key = file(var.publickeypath)
}

#---------------------create 2 private ec2 instances serving web traffic---------------------------
resource "aws_instance" "ec2-sg1" {
  count = var.counts
  ami = "${data.aws_ami.ami.id}"
  instance_type = var.instancetype
  vpc_security_group_ids = [ var.ec2-sg ]
  key_name = "${aws_key_pair.keypair.id}"
  #availability_zone = "${data.aws_availability_zones.list_az.names[count.index]}"
  tags = {
    Name = "ec2-sg-${count.index + 1}"
  }
  subnet_id = "${element(var.private-subnets, count.index)}" 
}

#---------------------create a bastion host with public ip enabled for ssh access  and to access private ec2 resources-----------------------
resource "aws_instance" "bastion-host" {
  ami = "${data.aws_ami.ami.id}"
  count = 1
  instance_type = var.instancetype
  vpc_security_group_ids = [ var.bastion-sg ]
  key_name = "${aws_key_pair.keypair.id}"
  availability_zone = "${data.aws_availability_zones.list_az.names[count.index]}"
  tags = {
    Name = "bastion-sg-host-${count.index + 1}"
  }
  subnet_id = "${element(var.public-subnet, count.index)}"
  associate_public_ip_address = true  
 }
