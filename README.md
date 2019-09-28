# terraform-aws-secure-webapplication
This project is for architecting a secure web application using natgateway, bastion host and aplication load balancer hosted on aws using terraform 

This project will create a bastion host for securing access to login to private ec2 web servers that are hosting web application and attached to an application load balancer



Design
-------------------------
Check diagram lab_diagram_CreatingSecureWebApplicationFromScratch.png for the design of this end project


Usage
-----------------------------------

I did not load my aws credentials using variables or in any file. I have exported the default region, access key and secret on the shell to run my terraform init, get, plan, apply, destroy

export AWS_DEFAULT_REGION="us-east-1"

export AWS_ACCESS_KEY_ID="AKI*****************"

export AWS_SECRET_ACCESS_KEY="vsfs********"

terraform validate

terraform init

terraform plan -out=tfplan

terraform apply tfplan

terraform destroy -auto-approve


Output
--------------------------------------------
Apply complete! Resources: 28 added, 0 changed, 0 destroyed.

State path: terraform.tfstate

Outputs:

S3_bucketname = bucket name is s3 bucket id is aws-terraf-59880

a-loadbalancer-dnsname = aws-alb-182****.us-east-1.elb.amazonaws.com

bastion_vm-sg = sg-059bfc608f0a3cd49

bastionhost-publicip = [
  "3.219.34.123",
]

ec2-private_vm-securitygroup = sg-07cebb2ef2106025b

ec2-private_vm_ips = [
  "10.123.3.41",
  "10.123.4.22",
]

ec2_keypair = the keypair name is tfs-key

internetgateway-id = igw-00df530ff48a2e344

loadbalancer-secgroup = sg-08e7b14e64ef2fb90

natgateway-publicip = 3.231.125.77

privatesubnets = [
  "subnet-01ef7110a893c4046",
  "subnet-0903775097188ec1c",
]

publicsubnet = [
  "subnet-04b07d45fc97435c9",
  "subnet-0d5e6f67c5107b7cb",
]

vpc-id = vpc-01e28e0dba8de4bd4
