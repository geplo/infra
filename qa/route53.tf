resource "aws_route53_record" "qa_api" {
  zone_id = "${var.route53_zone_id}"
  name    = "${var.api_dns}"
  type    = "A"

  alias {
    name                   = "${aws_elb.qa_api.dns_name}"
    zone_id                = "${aws_elb.qa_api.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "qa_frontend" {
  zone_id = "${var.route53_zone_id}"
  name    = "${var.frontend_dns}"
  type    = "A"

  alias {
    name                   = "${aws_elb.qa_frontend.dns_name}"
    zone_id                = "${aws_elb.qa_frontend.zone_id}"
    evaluate_target_health = true
  }
}
