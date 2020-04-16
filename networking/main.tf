#------------------------module/networking/main.tf------------------------------

data "aws_availability_zones" "available_az" {
}
#---------------create a vpc--------------------------
resource "aws_vpc" "tfs_vpc" {
  cidr_block = var.cidrblock
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "tf-vpc"
  }
}

#-----------internet gateway resource in the vpc to talk to internet-------------
resource "aws_internet_gateway" "tfs_ig" {
  vpc_id = "${aws_vpc.tfs_vpc.id}"
  tags = {
    Name = "tf-ig"
  }
}
#-------------public and private table routes-------------------
resource "aws_route_table" "public-route" {
  vpc_id = "${aws_vpc.tfs_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.tfs_ig.id}"
  }
  tags = {
    Name = "tfs-route-public"
  }
}

resource "aws_route_table" "private-route" {
  vpc_id = "{aws_vpc.tfs_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat-gw.id}"
  }
  tags = {
    Name = "tfs-route-private"
  }
}

#---------------------public and private subnet resources---------------------
resource "aws_subnet" "tfs_public-subnet" {
  count = 2
  cidr_block = var.cidr_public[count.index]
  vpc_id = "${aws_vpc.tfs_vpc.id}"
  availability_zone  = "${data.aws_availability_zones.available_az.names[count.index]}"
  tags = {
    Name = "tfs-public-subnets-${count.index + 1}"
  }

}

resource "aws_subnet" "tfs_private-subnet" {
  count = length(aws_subnet.tfs_public-subnet)
  cidr_block = var.cidr_private[count.index]
  vpc_id = "${aws_vpc.tfs_vpc.id}"
  availability_zone = "${data.aws_availability_zones.available_az.names[count.index]}"
  tags = {
    Name = "tfs-private-subnets-${count.index + 1}"
  }
}
#--------------public and private route tables associations to subnets------------------
resource "aws_route_table_association" "tfs-public-rta" {
  count = length(aws_subnet.tfs_public-subnet)
  subnet_id = "${aws_subnet.tfs_public-subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.public-route.id}"
}

resource "aws_route_table_association" "tfs-private-rta" {
  count = length(aws_subnet.tfs_private-subnet)
  subnet_id = "${aws_subnet.tfs_private-subnet.*.id[count.index]}"
  route_table_id = "${aws_default_route_table.private-route.id}"
}

#-------allocate an elastic ip------------

resource "aws_eip" "nat-eip" {
  vpc = true
  depends_on = ["aws_internet_gateway.tfs_ig"]
}

#------------------aws nat gateway for private subnet resources to talk to internet---------------

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = "${aws_eip.nat-eip.id}"
  subnet_id = "${aws_subnet.tfs_public-subnet[1].id}"
  depends_on = ["aws_internet_gateway.tfs_ig"]
  tags = {
    Name = "nat-GW"
  }
}



#-------------------------bastion host security group------------------------------
resource "aws_security_group" "bastion-sg" {
  name = "bastion-sg"
  vpc_id = "${aws_vpc.tfs_vpc.id}"
  
  ingress {
    from_port = 22
    to_port = 22 
    protocol = "tcp"
    cidr_blocks = [ var.accessIp ]
  }
 
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#----------------application load balancer security group-----------------------
resource "aws_security_group" "alb-sg" {
  name = "alb-sg"
  vpc_id = "${aws_vpc.tfs_vpc.id}"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#------------ec2 private security group--------------------
resource "aws_security_group" "ec2-sg" {
  name = "ec2-sg"
  vpc_id = "${aws_vpc.tfs_vpc.id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [ "${aws_security_group.bastion-sg.id}" ]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [ "${aws_security_group.alb-sg.id}" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




    
