resource "aws_elb" "prod_api" {
  # ELB metadata.
  name      = "${var.env}-api"
  instances = ["${aws_instance.prod_router_cluster.*.id}"]

  # Security groups.
  security_groups = []

  # ELB settings.
  internal                    = false
  idle_timeout                = 60
  connection_draining         = true
  connection_draining_timeout = 30
  cross_zone_load_balancing   = true

  # ELB environment settings.
  subnets = ["${module.vpc.subnet_ids}"]

  # Listeners.

  listener {
    instance_port     = 8080
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }
  listener {
    instance_port      = 8080
    instance_protocol  = "tcp"
    lb_port            = 443
    lb_protocol        = "ssl"
    ssl_certificate_id = "${var.ssl_cert_arn}"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/"
    interval            = 30
  }
  tags {
    Name        = "${var.env}-api"
    Environment = "${var.env}"
  }
}

resource "aws_elb" "prod_frontend" {
  # ELB metadata.
  name      = "${var.env}-api"
  instances = ["${aws_instance.prod_services_cluster.*.id}"]

  # Security groups.
  security_groups = []

  # ELB settings.
  internal                    = false
  idle_timeout                = 60
  connection_draining         = true
  connection_draining_timeout = 30
  cross_zone_load_balancing   = true

  # ELB environment settings.
  subnets = ["${module.vpc.subnet_ids}"]

  # Listeners.

  listener {
    instance_port     = 7777
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }
  listener {
    instance_port      = 7778
    instance_protocol  = "tcp"
    lb_port            = 443
    lb_protocol        = "ssl"
    ssl_certificate_id = "${var.ssl_cert_arn}"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/"
    interval            = 30
  }
  tags {
    Name        = "${var.env}-api"
    Environment = "${var.env}"
  }
}
