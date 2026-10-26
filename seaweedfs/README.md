# SeaweedFS

Create the `seaweedfs-admin-credentials` secret with:

```sh
kubectl create secret generic seaweedfs-admin-credentials -n <namespace> --from-literal=adminUser=admin --from-literal=adminPassword=<password>
```

Create the `seaweedfs-keycloak-secret` secret with:

```sh
kubectl create secret generic seaweedfs-keycloak-secret -n <namespace>  --from-literal=client-secret=$(terraform output -raw seaweedfs_client_secret)
```

Install/upgrade with:

```sh
helm upgrade --install --debug --atomic -n <namespace> -f seaweedfs/values.yaml --set seaweedfs.ingressHost=<url> --set seaweedfs.s3IngressHost=<url> --set seaweedfs.keycloakUrl=<url> seaweedfs seaweedfs
```
