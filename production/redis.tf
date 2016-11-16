resource "aws_elasticache_subnet_group" "prod_cache_subnet" {
  name       = "${var.env}_cacher_submet"
  subnet_ids = ["${module.vpc.subnet_ids}"]
}

resource "aws_elasticache_cluster" "prod_redis_cluster" {
  cluster_id = "${var.env}_redis"
  engine     = "redis"
  node_type  = "cache.t2.medium"

  num_cache_nodes   = 3
  subnet_group_name = "${aws_elasticache_subnet_group.prod_cache_subnet.id}"
}
