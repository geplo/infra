variable "name" {}

variable "env" {}

variable "cidr" {}

variable "azs" {
  type = "list"
}

variable "map_public_ip" {
  default = true
}

variable "enable_dns_hostnames" {
  default = true
}

variable "enable_dns_support" {
  default = true
}

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"

  tags {
    Name        = "${var.name}-vpc"
    Environment = "${var.env}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name        = "${var.name}-igw"
    Environment = "${var.env}"
  }
}

resource "aws_route" "route" {
  route_table_id         = "${aws_vpc.vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_subnet" "subnets" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet(aws_vpc.vpc.cidr_block, 2, count.index)}"
  availability_zone       = "${element(var.azs, count.index % length(var.azs))}"
  map_public_ip_on_launch = "${var.map_public_ip}"
  count                   = "${length(var.azs)}"

  tags {
    Name        = "${var.name}-subnet-${count.index}"
    Environment = "${var.env}"
  }
}

output "subnet_ids" {
  value = ["${aws_subnet.subnets.*.id}"]
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "route_table_id" {
  value = "${aws_route.route.id}"
}

output "env" {
  value = "${var.env}"
}

output "azs" {
  value = ["${var.azs}"]
}
