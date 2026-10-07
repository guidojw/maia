# keycloak

Install/upgrade with:

```sh
helm upgrade --install --debug --atomic -f keycloak/values.yaml -n <namespace> keycloak ./keycloak --set=ingressHost=<url>
```

The initial installation has to be done with the Keycloak custom resource disabled, add `--set hooks.keycloakCreate.enabled=false`.
