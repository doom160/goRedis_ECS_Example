resource "aws_ecr_repository" "go_redis_registry" {
  name                 = "go-redis"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecs_cluster" "go_redis_ecs_cluster" {
  name = "go-redis"
}