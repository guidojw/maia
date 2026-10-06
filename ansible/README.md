# Ansible

Ansible playbook for machines setup.

# Install collections

Change directory:

```sh
cd ansible
```

Install collections with:

```sh
ansible-galaxy install -r collections/requirements.txt
```

# Run playbook

Run the playbook with:

```sh
ansible-playbook -K site.yml
```
