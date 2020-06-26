# goRedis_ECS_Example
## Architecture Diagram

![Architecture Diagram](screenshot/aws.png)

This is built in Golang. This application fetches data from Elasticache Redis and show visitor count.

## How to run this on your own?
1. Fork this repository
1. Add secret key AWS_ACCESS_KEY, AWS_SECRET_KEY
1. Update vars.tf for both AWS_ACCESS_KEY, AWS_SECRET_KEY
1. Run Terraform Script
`terraform apply`
1. Any feature branch PR triggers pipeline
`.github\workflows\go.yml`
1. Visit this website: XXX