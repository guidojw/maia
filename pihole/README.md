# Pi-hole
Configuration files for Pi-hole.

### Stop systemd-resolved from listening on :53

1. `sudo nano /etc/systemd/resolved.conf`
2. Uncomment `DNS` and change to `1.1.1.1`.
3. Uncomment `DNSStubListener` and change to no.
4. Exit and save.
5. Create a symbolic link using `sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf`.
6. Reboot the system.

To undo this, comment `DNS` and `DNSStubListener` again, remove `/etc/resolv.conf` and reboot the system.
