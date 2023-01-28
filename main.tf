resource "aws_vpc" "Prod" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = "Prod"
  }
}

resource "aws_subnet" "prod_public_subnet" {
  vpc_id                  = aws_vpc.Prod.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    "Name" = "prod-public"
  }

}

resource "aws_internet_gateway" "prod-internet" {
  vpc_id = aws_vpc.Prod.id

  tags = {
    "Name" = "prod-igw"
  }

}
resource "aws_route_table" "prod-rt" {
  vpc_id = aws_vpc.Prod.id

  tags = {
    "Name" = "prod_public_rt"
  }

}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.prod-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.prod-internet.id

}

resource "aws_route_table_association" "prod_public_association" {
  subnet_id      = aws_subnet.prod_public_subnet.id
  route_table_id = aws_route_table.prod-rt.id

}

resource "aws_security_group" "prod-sg" {
  name        = "prod_sg"
  description = "prod security group"
  vpc_id      = aws_vpc.Prod.id

  ingress {
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