variable "env" {
  default = "prod"
}

variable "cidr" {
  default = "10.87.0.0/16"
}

variable "api_dns" {
  default = "api.leaf.ag"
}

variable "frontend_dns" {
  default = "www.leaf.ag"
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

# LB cluster.
resource "aws_instance" "prod_router_cluster" {
  count         = 3
  instance_type = "${var.instance_type}"

  ami                         = "${var.ami}"
  subnet_id                   = "${element(module.vpc.subnet_ids, count.index % length(module.vpc.subnet_ids))}"
  vpc_security_group_ids      = []
  key_name                    = "${var.ssh_key_name}"
  associate_public_ip_address = "${var.associate_public_ip}"

  tags {
    Name        = "router_cluster-${count.index + 1}"
    Environment = "${var.env}"
  }

  root_block_device {
    volume_size           = "${var.volume_size}"
    delete_on_termination = "${var.delete_on_termination}"
  }
}

# Edge servers.
resource "aws_instance" "prod_heartbeats_cluster" {
  count         = 2
  instance_type = "${var.instance_type}"

  ami                         = "${var.ami}"
  subnet_id                   = "${element(module.vpc.subnet_ids, count.index % length(module.vpc.subnet_ids))}"
  vpc_security_group_ids      = []
  key_name                    = "${var.ssh_key_name}"
  associate_public_ip_address = "${var.associate_public_ip}"

  tags {
    Name        = "heartbeats_cluster-${count.index + 1}"
    Environment = "${var.env}"
  }

  root_block_device {
    volume_size           = "${var.volume_size}"
    delete_on_termination = "${var.delete_on_termination}"
  }
}

# Generic cluster to hold services.
resource "aws_instance" "prod_services_cluster" {
  count         = 2
  instance_type = "${var.instance_type}"

  ami                         = "${var.ami}"
  subnet_id                   = "${element(module.vpc.subnet_ids, count.index % length(module.vpc.subnet_ids))}"
  vpc_security_group_ids      = []
  key_name                    = "${var.ssh_key_name}"
  associate_public_ip_address = "${var.associate_public_ip}"

  tags {
    Name        = "services_cluster-${count.index + 1}"
    Environment = "${var.env}"
  }

  root_block_device {
    volume_size           = "${var.volume_size}"
    delete_on_termination = "${var.delete_on_termination}"
  }
}

# ZK, Elasticsearch, NSQ lookupd, NSQ admin, etc.
resource "aws_instance" "prod_admin_cluster" {
  count         = 4
  instance_type = "${var.instance_type}"

  ami                         = "${var.ami}"
  subnet_id                   = "${element(module.vpc.subnet_ids, count.index % length(module.vpc.subnet_ids))}"
  vpc_security_group_ids      = []
  key_name                    = "${var.ssh_key_name}"
  associate_public_ip_address = "${var.associate_public_ip}"

  tags {
    Name        = "admin_cluster-${count.index + 1}"
    Environment = "${var.env}"
  }

  root_block_device {
    volume_size           = "${var.volume_size}"
    delete_on_termination = "${var.delete_on_termination}"
  }
}

# Dedicated cluster for unstable operations service.
resource "aws_instance" "prod_operations_cluster" {
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
