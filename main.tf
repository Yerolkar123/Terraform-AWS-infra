provider "aws" {
  region = "us-east-1"
}

terraform "registry.terraform.io/hashicorp/aws" { 
  
  required_version = ">= 0.15"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
