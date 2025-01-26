# Pi-hole
Configuration files for Pi-hole.

```sh
kubectl create secret generic admin-password \
  -n pihole \
  --from-literal=password=password
```
