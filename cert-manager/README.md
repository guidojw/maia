# cert-manager

On initial install, enable the CRDs and disable the extraObjects as they rely on the CRD existings:

```sh
helm install -n cert-manager --set cert-manager.crds.enabled=true --set cert-manager.extraObjects=null cert-manager cert-manager
```


Create the TransIP API private key secret (generate a key pair at https://www.transip.nl/cp/account/api/) before using the `letsencrypt-transip-*` ClusterIssuers:

```sh
kubectl -n cert-manager create secret generic transip-secret --from-file=privateKey=<path-to-private-key>
```

The issuers require `global.transip.accountName` (set by the workflow from the `TRANSIP_ACCOUNT_NAME` secret).

Then upgrade the chart with the values from the value file:

```sh
helm install --atomic --dependency-update -n cert-manager -f cert-manager/values.yaml --set global.transip.accountName=<transip-account-name> cert-manager cert-manager
```
