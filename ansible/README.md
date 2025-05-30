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

# Open VTY shell on hera
First SSH onto hera, then open a shell in the by the hera network role created container by running:
```sh
machinectl shell debian-custom
```

Then open VTY shell by running the `vtysh` command.
