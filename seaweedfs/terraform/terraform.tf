terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state"
    key    = "seaweedfs/terraform.tfstate"
    region = "eu-central-1"

    use_path_style  = true

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
  }
}

provider "aws" {
  region     = "eu-central-1"

  access_key = var.s3_access_key
  secret_key = var.s3_secret_key

  s3_use_path_style = true

  endpoints {
    iam = var.s3_endpoint
    s3  = var.s3_endpoint
  }

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
}
