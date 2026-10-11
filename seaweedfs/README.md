# SeaweedFS

Create the `seaweedfs-admin-credentials` secret with:

```sh
kubectl create secret generic seaweedfs-admin-credentials -n <namespace> --from-literal=adminUser=admin --from-literal=adminPassword=<password>
```

Create the `seaweedfs-keycloak-secret` secret with:

```sh
kubectl create secret generic seaweedfs-keycloak-secret -n <namespace>  --from-literal=client-secret=$(terraform output -raw seaweedfs_client_secret)
```

Get the S3 keys in `seaweedfs-s3-secret` with:

```sh
kubectl get secret seaweedfs-s3-secret -n <namespace> -o json | jq -r '.data | "Access key: \(.admin_access_key_id | @base64d)\nSecret key: \(.admin_secret_access_key | @base64d)"'
```

Install/upgrade with:

```sh
helm upgrade --install --debug --atomic -f seaweedfs/values.yaml -n <namespace> seaweedfs ./seaweedfs --set=ingressHost=<url>
```
