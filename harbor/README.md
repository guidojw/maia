Harbor
================

Configuration files for Harbor.

## Extra setup

The files in this directory are the only files that were modified after running the Harbor install script. 

1. Copy `harbor.service` to `/etc/systemd/system/harbor.service`.
2. Start Harbor by running `sudo systemctl start harbor`.
3. Enable Harbor by running `sudo systemctl enable harbor`.
