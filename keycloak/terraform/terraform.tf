terraform {
  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = ">= 4.4.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state"
    key    = "keycloak/terraform.tfstate"
    region = "eu-central-1"

    use_path_style  = true

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
  }
}

provider "keycloak" {
  client_id = "admin-cli"
  username  = var.keycloak_username
  password  = var.keycloak_password
  url       = var.keycloak_url
}
