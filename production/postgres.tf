resource "aws_db_subnet_group" "prod_db_subnet" {
  name        = "${var.env}_db_subnet"
  description = "DB subnet for production"
  subnet_ids  = ["${module.vpc.subnet_ids}"]
}

resource "aws_db_instance" "prod_postgresql_master" {
  allocated_storage = 500
  engine            = "postgres"
  engine_version    = "9.6.1"
  identifier        = "${var.env}_leaf"
  instance_class    = "db.t2.medium"

  name     = "leaf"
  username = "leaf"
  password = "leafleaf"

  #  backup_retention_period = "${var.backup_retention_period}"
  #  backup_window           = "${var.backup_window}"
  #  maintenance_window      = "${var.maintenance_window}"
  #  multi_az                = "${var.multi_availability_zone}"
  #  port                    = "${var.database_port}"
  #
  #  vpc_security_group_ids  = []
  db_subnet_group_name = "${aws_db_subnet_group.prod_db_subnet.id}"

  #  parameter_group_name    = "${var.parameter_group}"


  #  storage_encrypted       = "${var.storage_encrypted}"

  tags {
    Name        = "leaf"
    Environment = "${var.env}"
  }
}

resource "aws_db_instance" "prod_postgresql_replicas" {
  allocated_storage = 500
  engine            = "postgres"
  engine_version    = "9.6.1"
  identifier        = "leaf"
  instance_class    = "db.t2.medium"
  name              = "leaf"
  username          = "leaf"
  password          = "leafleaf"

  count               = 2
  replicate_source_db = "${aws_db_instance.prod_postgresql_master.id}"

  #  backup_retention_period = "${var.backup_retention_period}"
  #  backup_window           = "${var.backup_window}"
  #  maintenance_window      = "${var.maintenance_window}"
  #  multi_az                = "${var.multi_availability_zone}"
  #  port                    = "${var.database_port}"
  #
  #  vpc_security_group_ids  = []
  db_subnet_group_name = "${aws_db_subnet_group.prod_db_subnet.id}"

  #  parameter_group_name    = "${var.parameter_group}"


  #  storage_encrypted       = "${var.storage_encrypted}"

  tags {
    Name        = "leaf"
    Environment = "${var.env}"
  }
}
