# Traefik

Create a users file with:
```sh
htpasswd -c users username
```

Create the kubernetes secret containing the users file with:
```sh
kubectl create secret generic basic-auth-users -n traefik --from-file=users
```
