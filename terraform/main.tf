## Initial Setup ##

terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.96.0"
    }
  }

  backend "s3" {
    bucket = "cdn-waf-terraform-states"
    key    = "stage/bcgoat.net.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}
