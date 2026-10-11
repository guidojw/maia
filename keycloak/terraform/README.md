# Keycloak Terraform

Installation:

1. Copy `backend.conf.example` to `backend.conf` and insert the values for the environment.
1. Copy `variables.tfvars.example` to `variables.tfvars` and insert the values for the environment.
1. On initial apply, comment the `backend "s3"` block in `terraform.tf`.
1. Run `terraform init -backend-config=backend.conf`, this will initialise the plan environment's backend and install any providers.
1. Run any Terraform command with the options `-var-file=variables.tfvars`. Overwrite any variables by using `-var=<key>=<value>`:

```sh
terraform plan -var-file=variables.tfvars
```

4. Run `terraform apply -var-file=variables.tfvars` to apply the plan.
1. If this was the initial apply:
  1. Uncomment the `backend "s3"` block in `terraform.tf`.
  1. Run `terraform init -backend-config=backend.conf -migrate-state` to migrate the state from the local backend to the S3 backend.
  1. You can now safely remove the `terraform.tfstate` and `terraform.tfstate.backup` files.
