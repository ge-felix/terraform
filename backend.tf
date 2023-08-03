#Set S3 backend for persisting TF state file remotely, ensure bucket already exits
# And that AWS user being used by TF has read/write perms
terraform {
  required_version = ">=1.0.11"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.10.0"
    }
  }
  backend "s3" {
    region  = "eu-west-2"
    profile = "default"
    key     = "terraformstatefile"
    bucket  = "gf-cloudresume-chal-terraform"
  }
}