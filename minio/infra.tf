resource "minio_s3_bucket" "state_terraform_s3" {
  bucket = "state-terraform-s3"
  acl    = "public"
}

terraform {
  required_providers {
    minio = {
      source  = "aminueza/minio"
      version = "~> 2.0.1"
    }
  }
}
