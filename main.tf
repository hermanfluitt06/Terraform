terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "4.51.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
    default_tags {
      tags = var.default_tags
    }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  assign_generated_ipv6_cidr_block = true
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    "Name" = "${var.default_tags.env}"
  }
}


resource "aws_subnet" "public" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main,cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${var.default_tags.env}-Public-Subnet"
  }
}


resource "aws_subnet" "Private" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + var.public_subnet_count)
  tags = {
    "Name" = "${var.default_tags.env}-Priavte-Subnet" 
  }
}

