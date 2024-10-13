terraform {
  required_version = "~> 0.14.11"
  required_providers {
    aws = {
    source = "hashicorp/aws"
    version = "~> 5.70"
    }
  }
  backend "s3" {
    bucket = "slashdev.org-iac"
    key    = "slashdev/state"
    region = "us-east-1"
  }
}
