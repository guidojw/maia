Kubernetes
================

Configuration files for my k3s cluster.

This repository uses the k3s-ansible playbook at: https://github.com/guidojw/k3s-ansible

## Provisioning cluster
Run the playbook with:
```sh
ansible-playbook site.yml -i inventory/my-cluster/hosts.ini --ask-become-pass
```

Then, copy the kubeconfig from the server:
```sh
scp user@maya:~/.kube/config ~/.kube/config
```

Then, apply the namespaces and the service-accounts templates:
```sh
kubectl apply -f kubernetes/namespaces.yaml kubernetes/service-accounts.yaml
```

Now you can get a kubeconfig for continuous deployment (i.e. GitHub Actions) by running:
```sh
./kubernetes/get-service-account-config.sh
```

This wil output the kubeconfig to file `github-actions` in the project root.
If necessary, change the IP address in the cluster server config to an external domain/IP and then save it in a GitHub Actions secret.

## Removing cluster
Run the playbook with:
```sh
ansible-playbook reset.yml -i inventory/my-cluster/hosts.ini --ask-become-pass
```
