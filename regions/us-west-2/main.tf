variable "name" {
  default = "us-west-2"
}

variable "azs" {
  default = [
    "us-west-2a",
    "us-west-2b",
    "us-west-2c",
  ]
}

output "azs" {
  value = ["${var.azs}"]
}

output "name" {
  value = "${var.name}"
}

output "rancher_ami" {
  value = "ami-b506a3d5" # 2016-11-15, rancher 0.7.
}
