#!/usr/bin/env bash
# Helm post-renderer that adds the startup probes the app charts don't expose, so slow starts are not killed by the liveness probe.
# It also loosens their liveness and readiness probes, as a busy node CPU makes the default 1 second checks fail and restarts the apps.
set -euo pipefail

DIR=$(mktemp -d)
trap 'rm -rf "$DIR"' EXIT

cat > "$DIR/manifests.yaml"

{
  echo "resources:"
  echo "- manifests.yaml"
  echo "patches:"

  # Up to 5 minutes to start, e.g. for database migrations.
  for APP in sonarr radarr prowlarr bazarr; do
    # Not PATH, that would break command lookup.
    PROBE_PATH=/ping
    [[ $APP == bazarr ]] && PROBE_PATH=/
    cat <<EOF
- target:
    kind: Deployment
    name: $APP
  patch: |-
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: $APP
    spec:
      template:
        spec:
          containers:
          - name: $APP
            startupProbe:
              httpGet:
                path: $PROBE_PATH
                port: http
              periodSeconds: 10
              failureThreshold: 30
            livenessProbe:
              timeoutSeconds: 10
              failureThreshold: 12
            readinessProbe:
              timeoutSeconds: 10
              failureThreshold: 12
EOF
  done

  cat <<EOF
- target:
    kind: Deployment
    name: qbittorrent
  patch: |-
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: qbittorrent
    spec:
      template:
        spec:
          containers:
          - name: qbittorrent
            startupProbe:
              exec:
                command:
                - sh
                - -c
                - wget --no-verbose --tries=1 --spider http://localhost:8080 || exit 1
              periodSeconds: 10
              timeoutSeconds: 5
              failureThreshold: 30
            livenessProbe:
              timeoutSeconds: 10
              failureThreshold: 12
            readinessProbe:
              timeoutSeconds: 10
              failureThreshold: 12
          # The Gluetun sidecar, named gluten in the chart.
          initContainers:
          - name: gluten
            startupProbe:
              timeoutSeconds: 10
              failureThreshold: 30
            livenessProbe:
              timeoutSeconds: 10
              failureThreshold: 12
            readinessProbe:
              timeoutSeconds: 10
              failureThreshold: 12
EOF
} > "$DIR/kustomization.yaml"

kubectl kustomize "$DIR"
