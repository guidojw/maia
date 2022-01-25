Nextcloud
================

Configuration files for Pi-hole.

## Extra setup

1. Go into the Postgres container by running `docker-compose exec db bash`.
2. Open psql as the postgres user by running `psql -U postgres`.
3. Create a database named `nextcloud` by running `CREATEDB nextcloud;`.
4. Exit psql and the container.
5. Go into the Nextcloud container by running `docker-compose exec --user www-data app bash`.
6. Migrate from SQLite to PostgreSQL by running `./occ db:convert-type --port 5432 --all-apps --clear-schema pgsql postgres db nextcloud`.
7. Clear the `skeletondirectory` system setting by running `./occ config:system:set skeletondirectory --value=''`.
8. Change the `overwriteprotocol` system setting to `https` by running `./occ config:system:set overwriteprotocol --value=https`.
9. Change the `overwrite.cli.url` system setting to use `https` by running `./occ config:system:set overwrite.cli.url --value=https://nextcloud.example.com`.
