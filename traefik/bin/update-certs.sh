#!/bin/bash
kubectl cp -n traefik "$(kubectl get pod -n traefik -o jsonpath="{.items[0].metadata.name}")":data/acme.json acme.json
traefik-certs-dumper.exe file --domain-subdir
for FILE in dump/**.guidojw.nl; do
  NAME=${FILE:5:-11}
  kubectl create secret tls ${NAME/./-}-legacy-cert \
    -n traefik \
    --cert=dump/$NAME.guidojw.nl/certificate.crt \
    --key=dump/$NAME.guidojw.nl/privatekey.key
done

# kubectl get secret -n traefik legacy-cert -o jsonpath="{.data['tls\.crt']}" | base64 --decode > tls.crt
# kubectl get secret -n traefik legacy-cert -o jsonpath="{.data['tls\.key']}" | base64 --decode > tls.key
# scp tls.crt guido@192.168.1.55:/opt/docker/traefik/dynamic/tls.crt
# scp tls.key guido@192.168.1.55:/opt/docker/traefik/dynamic/tls.key
