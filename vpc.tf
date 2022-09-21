terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

module "aws_vpc" {
  source             = "./modules/aws/vpc"
  aws_region         = "us-east-1"
  aws_vpc_cidr_block = "10.0.0.0/16"
  aws_vpc_name       = "my-vpc"
}
