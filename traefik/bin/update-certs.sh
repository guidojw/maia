#!/bin/bash
kubectl get secret -n traefik legacy-cert -o jsonpath="{.data['tls\.crt']}" | base64 --decode > tls.crt
kubectl get secret -n traefik legacy-cert -o jsonpath="{.data['tls\.key']}" | base64 --decode > tls.key

scp tls.crt guido@192.168.1.55:/opt/docker/traefik/dynamic/tls.crt
scp tls.key guido@192.168.1.55:/opt/docker/traefik/dynamic/tls.key
