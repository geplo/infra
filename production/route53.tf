resource "aws_route53_record" "prod_api" {
  zone_id = "${var.route53_zone_id}"
  name    = "${var.api_dns}"
  type    = "A"

  alias {
    name                   = "${aws_elb.prod_api.dns_name}"
    zone_id                = "${aws_elb.prod_api.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "prod_frontend" {
  zone_id = "${var.route53_zone_id}"
  name    = "${var.frontend_dns}"
  type    = "A"

  alias {
    name                   = "${aws_elb.prod_frontend.dns_name}"
    zone_id                = "${aws_elb.prod_frontend.zone_id}"
    evaluate_target_health = true
  }
}
