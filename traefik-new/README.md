# Traefik

Create a users file with:

```sh
htpasswd -c users username
```

Create the kubernetes secret containing the users file with:

```sh
kubectl create secret generic basic-auth-users -n traefik --from-file=users
```

Install or upgrade with:

```sh
helm upgrade --install --atomic -n traefik --set "traefik.ingressRoute.dashboard.matchRule=Host(\`<host>\`) && (PathPrefix(\`/dashboard\`) || PathPrefix(\`/api\`))" --set global.ingressHost=<host> --set "global.legacyUrls={<host>,<host>}" traefik traefik-new
```
