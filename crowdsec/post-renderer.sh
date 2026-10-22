#!/usr/bin/env bash
# Helm post-renderer for the crowdsec chart, which has no option for these two changes:
# the LAPI and agent pods do not mount the Kubernetes API token, and the agent's registration init container
# waits with bash instead of nc, which the Debian image lacks.
set -euo pipefail

DIR=$(mktemp -d)
trap 'rm -rf "$DIR"' EXIT

cat > "$DIR/manifests.yaml"

cat > "$DIR/kustomization.yaml" <<'EOF'
resources:
- manifests.yaml
patches:
- target:
    kind: Deployment
    name: .*-lapi
  patch: |-
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: ignored
    spec:
      template:
        spec:
          automountServiceAccountToken: false
- target:
    kind: DaemonSet
    name: .*-agent
  patch: |-
    apiVersion: apps/v1
    kind: DaemonSet
    metadata:
      name: ignored
    spec:
      template:
        spec:
          automountServiceAccountToken: false
          initContainers:
          - name: wait-for-lapi-and-register
            command:
            - sh
            - -c
            - >-
              until bash -c 'echo > /dev/tcp/$LAPI_HOST/$LAPI_PORT' 2>/dev/null; do echo waiting for lapi to start; sleep 5; done;
              ln -s /staging/etc/crowdsec /etc/crowdsec &&
              cscli lapi register --machine "$USERNAME" -u "$LAPI_URL" --token "$REGISTRATION_TOKEN" &&
              cp /etc/crowdsec/local_api_credentials.yaml /tmp_config/local_api_credentials.yaml
EOF

kubectl kustomize "$DIR"
