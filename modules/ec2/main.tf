variable "ami" {}

variable "env" {}

variable "instance_type" {
  default = "t2.medium"
}

variable "ssh_key_name" {}

variable "servers" {
  default = 1
}

variable "security_group_ids" {
  type = "list"
}

variable "subnet_ids" {
  type = "list"
}

variable "name" {}

variable "associate_public_ip" {
  default = true
}

variable "delete_on_termination" {
  default = true
}

variable "volume_size" {
  default = 100
}

resource "aws_instance" "ec2_cluster" {
  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${element(var.subnet_ids, count.index % length(var.subnet_ids))}"
  vpc_security_group_ids      = ["${var.security_group_ids}"]
  key_name                    = "${var.ssh_key_name}"
  count                       = "${var.servers}"
  associate_public_ip_address = "${var.associate_public_ip}"

  tags = {
    Name        = "${var.name}-${count.index + 1}"
    Environment = "${var.env}"
  }

  root_block_device {
    volume_size           = "${var.volume_size}"
    delete_on_termination = "${var.delete_on_termination}"
  }
}

output "name" {
  value = "${var.name}"
}

output "ids" {
  value = ["${aws_instance.ec2_cluster.*.id}"]
}

output "public_dns" {
  value = ["${aws_instance.ec2_cluster.*.public_dns}"]
}

output "private_dns" {
  value = ["${aws_instance.ec2_cluster.*.private_dns}"]
}
