terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  tags = {
    Project     = "aws_vpc_project"
    team        = "config management"
    Environment = "dev"
  }

}