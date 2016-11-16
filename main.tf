module "region" {
  source = "./regions/us-west-2"
}

provider "aws" {
  region = "${module.region.name}"
}

# 2016 certificate for *.leaf.ag.
variable "ssl_cert_arn" {
  default = "arn:aws:iam::214995360173:server-certificate/2016.leaf.ag"
}

variable "ssh_key_name" {
  default = "guillaume"
}

variable "route53_zone_id" {
  default = "ZJN6YABZP2OQA"
}

module "production" {
  source = "./production"

  ami = "${module.region.rancher_ami}"
  azs = "${module.region.azs}"

  ssh_key_name    = "${var.ssh_key_name}"
  ssl_cert_arn    = "${var.ssl_cert_arn}"
  route53_zone_id = "${var.route53_zone_id}"
}

module "qa" {
  source = "./qa"

  ami = "${module.region.rancher_ami}"
  azs = "${module.region.azs}"

  ssh_key_name    = "${var.ssh_key_name}"
  ssl_cert_arn    = "${var.ssl_cert_arn}"
  route53_zone_id = "${var.route53_zone_id}"
}
