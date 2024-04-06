Ansible
================

Ansible playbook for machines (network) setup.

# Install collections
Install collections with:
```sh
ansible-galaxy install -r ansible/collections/requirements.txt
```

# Run playbook
Run the playbook with:
```sh
ansible-playbook ansible/site.yml -l <host_group>
```
