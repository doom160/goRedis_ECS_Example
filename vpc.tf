# VPC Variables

variable "vpc_cidr" {
	default = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
	default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
	default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "azs" {
	default = ["ap-southeast-1a", "ap-southeast-1b"]
}

# VPC
resource "aws_vpc" "go-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = "true" #gives you an internal domain name
  enable_dns_hostnames = "true"  #gives you an internal host name
  enable_classiclink = "false"
  instance_tenancy = "default"    
  tags = {
    application="go-redis"
  }
}

# Subnet
resource "aws_subnet" "go-public-subnet" {
  count = length(var.public_subnets_cidr)
  vpc_id = aws_vpc.go-vpc.id
  cidr_block = element(var.public_subnets_cidr,count.index)
  availability_zone = element(var.azs,count.index)
  tags = {
    application="go-redis"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "go-igw" {
  vpc_id = aws_vpc.go-vpc.id
}

# Routing Table
resource "aws_route_table" "go-public-rt" {
  vpc_id = aws_vpc.go-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.go-igw.id
  }
}

# Route table association with public subnets
resource "aws_route_table_association" "go-associate" {
  count =  length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.go-public-subnet.*.id,count.index)
  route_table_id = aws_route_table.go-public-rt.id
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.go-vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}