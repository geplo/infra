resource "aws_elasticache_subnet_group" "qa_cache_subnet" {
  name       = "${var.env}_cacher_submet"
  subnet_ids = ["${module.vpc.subnet_ids}"]
}

resource "aws_elasticache_cluster" "qa_redis_cluster" {
  cluster_id = "qa_redis"
  engine     = "redis"
  node_type  = "cache.t2.micro"

  num_cache_nodes   = 1
  subnet_group_name = "${aws_elasticache_subnet_group.qa_cache_subnet.id}"
}
