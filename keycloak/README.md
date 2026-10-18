# Keycloak

Install/upgrade with:

```sh
helm upgrade --install --debug --atomic -n <namespace> -f keycloak/values.yaml --set=keycloak.ingressHost=<url> keycloak keycloak
```

The initial installation has to be done with the Keycloak custom resource disabled, add `--set keycloak.hooks.keycloakCreate.enabled=false`.
