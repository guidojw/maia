# cert-manager

On initial install, enable the CRDs and disable the extraObjects as they rely on the CRD existings:

```sh
helm install -n cert-manager --set cert-manager.crds.enabled=true --set cert-manager.extraObjects=null cert-manager cert-manager
```


Then upgrade the chart with the values from the value file:

```sh
helm install --atomic --dependency-update -n cert-manager -f cert-manager/values.yaml cert-manager cert-manager
```
