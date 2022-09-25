provider "aws" {
  region = "us-east-1"
}

terraform { 
  
  required_version = ">= 0.15"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

data "aws_availability_zones" "azA" {

state = "available"

}
data "aws_availability_zones" "azB" {

state = "available"

}
provider "random" {}
