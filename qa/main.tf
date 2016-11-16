variable "env" {
  default = "qa"
}

variable "cidr" {
  default = "10.88.0.0/16"
}

variable "api_dns" {
  default = "qa-api.leaf.ag"
}

variable "frontend_dns" {
  default = "qa.leaf.ag"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "associate_public_ip" {
  default = true
}

variable "delete_on_termination" {
  default = true
}

variable "volume_size" {
  default = 100
}

variable "ssh_key_name" {}

variable "ami" {}

variable "ssl_cert_arn" {}

variable "route53_zone_id" {}

variable "azs" {
  type = "list"
}

# Generic cluster to hold services.
resource "aws_instance" "qa_generic_cluster" {
  count         = 1
  instance_type = "${var.instance_type}"

  ami                         = "${var.ami}"
  subnet_id                   = "${element(module.vpc.subnet_ids, count.index % length(module.vpc.subnet_ids))}"
  vpc_security_group_ids      = []
  key_name                    = "${var.ssh_key_name}"
  associate_public_ip_address = "${var.associate_public_ip}"

  tags {
    Name        = "generic_cluster-${count.index + 1}"
    Environment = "${var.env}"
  }

  root_block_device {
    volume_size           = "${var.volume_size}"
    delete_on_termination = "${var.delete_on_termination}"
  }
}

# Dedicated cluster for unstable operations service.
resource "aws_instance" "qa_operations_cluster" {
  count         = 1
  instance_type = "t2.small"

  ami                         = "${var.ami}"
  subnet_id                   = "${element(module.vpc.subnet_ids, count.index % length(module.vpc.subnet_ids))}"
  vpc_security_group_ids      = []
  key_name                    = "${var.ssh_key_name}"
  associate_public_ip_address = "${var.associate_public_ip}"

  tags {
    Name        = "operations_cluster-${count.index + 1}"
    Environment = "${var.env}"
  }

  root_block_device {
    volume_size           = "${var.volume_size}"
    delete_on_termination = "${var.delete_on_termination}"
  }
}
