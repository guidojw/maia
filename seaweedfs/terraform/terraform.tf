terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state"
    key    = "seaweedfs/terraform.tfstate"
    region = "eu-central-1"

    use_path_style = true

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "aws" {
  region = "eu-central-1"

  access_key = data.kubernetes_secret_v1.s3_credentials.data["admin_access_key_id"]
  secret_key = data.kubernetes_secret_v1.s3_credentials.data["admin_secret_access_key"]

  s3_use_path_style = true

  endpoints {
    iam = "https://${data.kubernetes_secret_v1.s3_cert.metadata[0].annotations["cert-manager.io/common-name"]}"
    s3  = "https://${data.kubernetes_secret_v1.s3_cert.metadata[0].annotations["cert-manager.io/common-name"]}"
  }

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
}
