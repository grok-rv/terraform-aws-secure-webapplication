output "keypair" {
  value = "the keypair name is ${aws_key_pair.keypair.key_name}"
}

output "ec2instance_id" {
  value = "${join(", ", aws_instance.ec2-sg1.*.id)}"
}
output "ec2instance-ip" {
  value = "${aws_instance.ec2-sg1.*.private_ip}"
}
output "ec2publicip" {
  value = "${join(", ", aws_instance.ec2-sg1.*.public_ip)}"
}
output "bastionhost" {
  value = "${aws_instance.bastion-host.*.public_ip}"
}
