MinIO
================

Charts and configurations for my MinIO instance.

# Setting up
Create the namespace with:
```sh
kubectl apply -f minio/namespaces.yaml
```

Create the used secret with:
```sh
export MINIO_ROOT_USER=<username>
export MINIO_ROOT_PASSWORD=<password>
kubectl -n minio create secret generic minio-secret \
  --from-literal=config.env="export MINIO_ROOT_USER=$MINIO_ROOT_USER"$'\n'"export MINIO_ROOT_PASSWORD=$MINIO_ROOT_PASSWORD"
```

Install the MinIO Operator:
```sh
helm install minio-operator minio/operator --atomic -n minio
```

Install the MinIO Tenant:
```sh
helm install minio-tenant minio/tenant --atomic -f minio/tenant/values.yaml -n minio
```

# Testing
Now to test the tenant, you can port forward to it by running:
```sh
kubectl -n minio port-forward svc/console 9090:9090
```

Get the root user login JWT:
```sh
kubectl -n minio get secrets console-sa-secret -o jsonpath="{.data.token}" | base64 --decode
```
