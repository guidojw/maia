Cloudflare configurations
================

Configuration files for Cloudflare DNS and Cloudflare Tunnel.

## Setup

1. Change the `config` directory permissions by running `chown -R 65532:65532 ./config`.
2. Login to Cloudflare by running `docker-compose run --rm cloudflared tunnel login`.
3. Create a tunnel by running `docker-compose run --rm cloudflared tunnel create <name>`.
4. Change the `tunnel` in `config/config.yml` to the created tunnel's identifier and change the `credentials-file` accordingly.
5. Configure every service that is routed through the tunnel in `config.config.yml`.

## Configure local SSH client

https://developers.cloudflare.com/cloudflare-one/tutorials/ssh/#native-terminal
