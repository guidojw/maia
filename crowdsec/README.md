# CrowdSec

Wraps the official [crowdsec chart](https://github.com/crowdsecurity/helm-charts) (LAPI + agent) and adds a [cs-routeros-bouncer](https://github.com/jmrplens/cs-routeros-bouncer) deployment.

The agent (DaemonSet) reads the Traefik container logs from `/var/log/containers` and the node's sshd logs from the systemd journal, the LAPI (Deployment) turns them into decisions and the bouncer syncs the decisions to the MikroTik firewall address lists via the RouterOS API.

Hardening: dropped capabilities and seccomp on all pods, no Kubernetes API token mounted (`post-renderer.sh` for the engine pods, as the chart has no option for it), bouncer runs as non-root with a read-only root filesystem, secrets come from a Kubernetes Secret, default-deny NetworkPolicies (only LAPI/agent/bouncer traffic, HTTPS to the internet for the Central API and hub, and the RouterOS API), RouterOS API over TLS, and a dedicated minimal RouterOS user.

## RouterOS

Create a self-signed certificate for the TLS API (or use an existing one, see `/certificate print`):

```routeros
/certificate add name=api-ssl common-name=<router ip or hostname> days-valid=3650
/certificate sign api-ssl
```

Create a dedicated user and enable the TLS API with that certificate.
Quote the password, escaping `"`, `\` and `$` with a backslash (an alphanumeric password needs no escaping):

```routeros
/user group add name=crowdsec policy=read,write,api,!sensitive,!ftp,!local,!ssh,!reboot,!policy,!test,!password,!sniff,!romon,!rest-api
/user add name=crowdsec group=crowdsec password="<password>" address=<node ip>
/ip service set api-ssl certificate=api-ssl available-from=<node ip>/32 disabled=no
```

`certificate=` takes the certificate name from `/certificate print`, which should show the `K` flag (private key).
`address=` (user) and `available-from=` (service) restrict access to the cluster node.
The self-signed router certificate has no subject alternative name, so the install sets `crowdsec.bouncer.mikrotik.tlsInsecure=true`.

## Install

Create the namespace and the secret with the bouncer key (any random string, registered in the LAPI at startup), the RouterOS password and the CrowdSec Console enrollment key (from app.crowdsec.net, accept the instance in the console after the install):

```sh
kubectl create secret generic crowdsec-routeros-bouncer -n crowdsec \
  --from-literal=api-key="$(openssl rand -hex 32)" \
  --from-literal=mikrotik-password='<password>' \
  --from-literal=enroll-key='<enrollment key>' \
  --from-literal=discord-webhook-url='<discord webhook url>'
```

The `enroll-key` is optional, without it the instance is not enrolled.
The `discord-webhook-url` is where the LAPI posts a message for every ban from a local detection (the community blocklist does not notify).

Install or upgrade with:

```sh
helm upgrade --install --debug --atomic -n crowdsec --post-renderer crowdsec/post-renderer.sh -n crowdsec -f crowdsec/values.yaml --set crowdsec.bouncer.mikrotik.address=<router ip>:8729 --set crowdsec.bouncer.mikrotik.tlsInsecure=true --set crowdsec.networkPolicy.router.cidr=<router ip>/32 crowdsec crowdsec
```

The post-renderer requires `kubectl`, and the agent only starts with it: it replaces the `nc` wait in the registration init container, which the Debian image does not contain.
It also stops the engine pods from mounting the API token.

Optionally add `--set crowdsec.networkPolicy.metricsNamespace=<namespace>` to let Prometheus scrape the metrics ports.

## Whitelist

CrowdSec ignores events from `127.0.0.0/8`, `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16` and `::1` by default.
`crowdsec.whitelist.cidrs` adds unique local IPv6 and the Cloudflare proxies.

LAN clients that use global IPv6 addresses are not covered, as the prefix is specific to your ISP.

Add it to the install command:

```sh
  --set "crowdsec.whitelist.extraCidrs={<ipv6 prefix>/<length>}"
```


Restart the agent with:

```sh
kubectl rollout restart -n crowdsec daemonset/crowdsec-agent
```

## Notes

- Run `cscli` in the LAPI pod with:

  ```sh
  kubectl exec -n crowdsec deploy/crowdsec-lapi -- cscli <command>
  ```

  Example commands are `cscli decisions list`, `cscli alerts list`, `cscli capi status`, `cscli console status` and `cscli notifications test discord`.
- Traefik's access log must be enabled and its pods must be named `traefik-*` in the `traefik` namespace (see `engine.agent.acquisition`).
- Bans are only useful if the log contains the real client IP.
  Traefik takes it from `X-Forwarded-For` for the trusted IPs (`forwardedHeaders.trustedIPs`) and otherwise from the connection, so the Traefik service must preserve the source IP.
- By default all decisions are pushed to the router, including the community blocklist (about 20k entries) and the blocklists you subscribed to in the console.
  Restrict them with `crowdsec.bouncer.crowdsec.origins`, e.g. `[crowdsec, cscli]` for local decisions only.
- The agent runs as uid 65532 with a read-only root filesystem and all capabilities dropped.
  It reads the Traefik logs (`root:root` `0640` on the node) through group 0 (`supplementalGroups`), and only `/var/log/pods` and `/var/log/containers` are mounted, read-only, besides the journal below.
  `/staging`, `/etc/crowdsec`, `/var/lib/crowdsec` and `/tmp` are emptyDirs seeded by init containers (a root one that copies the image's `/staging` and makes the registration credentials group-readable, and a uid 65532 one that makes the agent-owned copies).
  Group 0 can read the logs of every pod on the node.
- The agent reads the sshd logs of the node (`ssh.service`) from the systemd journal with `journalctl`, which only the Debian image variant (`engine.image.tag`, `-debian`) contains.
  It needs the host's persistent journal (`/var/log/journal`, group 999 `systemd-journal`, mounted read-only with `supplementalGroups`) and `/etc/machine-id` to find the journal files.
  Check the group ID with `ls -ln /var/log/journal`; on a node with only a volatile journal, mount `/run/log/journal` instead.
  The journal mount lets the agent read all units, the acquisition only processes `ssh.service`.
  Check it with `kubectl exec -n crowdsec ds/crowdsec-agent -- cscli metrics show acquisition`.
- The LAPI runs with all capabilities dropped.
- Check that the bouncer is registered, that logs are being parsed and that the bouncer syncs to the router with:

  ```sh
  kubectl exec -n crowdsec deploy/crowdsec-lapi -- cscli bouncers list
  kubectl exec -n crowdsec deploy/crowdsec-lapi -- cscli metrics
  kubectl logs -n crowdsec deploy/crowdsec-routeros-bouncer
  ```
