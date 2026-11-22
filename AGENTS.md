# Agent instructions

Repository for server configuration: Helm charts and Docker Compose files for a single-node k3s cluster (`media`, `traefik`, `keycloak`, `pihole`, ...) plus Ansible and Terraform.

## Communication

- Keep answers short and impersonal, no emojis, no time estimates.
- Say plainly when something is unverified or from memory (UI labels, setting names, hardware advice). Do not present a guess as a result.
- When a finding contradicts an earlier answer, say so and correct it.
- State trade-offs before a change that removes access or functionality, and offer the opt-in or opt-out instead of choosing silently.
- Link files as workspace-relative markdown links, never as plain names or in backticks.

## Working with the cluster

- Cluster access is read-only by default: `get`, `describe`, `logs`, `top`, `exec` for inspection. The user runs every `helm upgrade` and every other change themselves, so give the flags they need to add instead of running it.
- Ask before deleting or restarting anything (pods, PVCs, files) and before anything that interrupts a running stream or download.
- If the control-plane VIP is unreachable, use its node address: `kubectl --server=<address>`.
- Test risky settings (security contexts, volume ownership, capabilities) on a throwaway pod with `emptyDir` volumes, never on real volumes, and delete the pod afterwards.
- Do not read or use secrets and tokens without asking, and never print them.
- Diagnose with evidence (logs, Cilium `monitor`, Pi-hole query log, pod log) before proposing a fix, and re-check the live state after the user says they changed something.

## Helm charts and values

- Values that are not official values of a subchart live nested under the root key named the Helm chart name in `values.yaml`.
- Keep dependencies in `Chart.yaml` and the root sections of `values.yaml` in alphabetical order, apart from the existing `global` and Helm chart name blocks at the top.
- Put the official comment of the chart in front of every subchart value that is set, copied from the chart's own `values.yaml` without the `# --` marker. Look it up in the packaged chart (`tar -xzOf charts/<chart>.tgz <chart>/values.yaml`).
- Add a custom comment only when the code can not show the reason, as one short line directly above the exact line it explains (for example above `readOnly: true` or the init container name, not above the parent key). Remove custom comments when asked.
- Hosts, domains and secrets are never hardcoded: they come in through `--set` on the `helm upgrade` command. New options that are normally passed that way get a documented empty default.
- Change only what is asked. When a feature is removed, remove it everywhere: templates, values, README and the install command.
- Anything an app has behind the Keycloak login (`oauth2-proxy` with the `keycloak-auth` middleware) must never be exposed without it.

## README

- Update the README files in the same change whenever behaviour, values or the install command change. Keep any overview diagram directly under the title.
- No dead anchors, no literal `\n` in the text, no double blank lines, no trailing whitespace, and files end with a single newline.

## Verification

- After every edit confirm it landed with a terminal `grep` or `read_file`, as the search tool can be stale right after an edit.
- Render and lint with the required values before reporting done.
- Before the user deploys, run a server-side dry run of their real command (`helm upgrade --install --dry-run=server ...`) and report what could not be tested.

## Security

- Minimise the attack surface by default: no Kubernetes API token mounted (`automount: false`), `allowPrivilegeEscalation: false`, capabilities dropped, seccomp `RuntimeDefault`, non-root where the image supports it, libraries mounted read-only.
- Give workloads memory and CPU requests or limits so an intensive task or an OOM can not take down the control plane (kube-vip, k3s).
