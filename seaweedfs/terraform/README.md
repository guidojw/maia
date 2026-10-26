# SeaweedFS Terraform

Installation:

1. Copy `backend.conf.example` to `backend.conf` and insert the values for the environment.
1. On initial apply, comment the `backend "s3"` block in `terraform.tf`.
1. Run `terraform init -backend-config=backend.conf`, this will initialise the plan environment's backend and install any providers.
1. Run Terraform plan:

   ```sh
   terraform plan
   ```

1. Run `terraform apply` to apply the plan.
1. If this was the initial apply:
  1. Uncomment the `backend "s3"` block in `terraform.tf`.
  1. Run `terraform init -backend-config=backend.conf -migrate-state` to migrate the state from the local backend to the S3 backend.
  1. You can now safely remove the `terraform.tfstate` and `terraform.tfstate.backup` files.
1. Get the `terraform-admin` user S3 keys in the outputs with:

   ```sh
   printf 'Access key: %s\nSecret key: %s\n' "$(terraform output -raw s3_production_access_key)" "$(terraform output -raw s3_production_secret_key)"
   ```
