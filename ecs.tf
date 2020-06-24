resource "aws_ecr_repository" "go_redis_registry" {
  name                 = "go-redis"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}