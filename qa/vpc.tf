module "vpc" {
  source        = "../modules/vpc"
  name          = "${var.env}-vpc"
  env           = "${var.env}"
  map_public_ip = true
  cidr          = "${var.cidr}"
  azs           = ["${var.azs}"]
}
