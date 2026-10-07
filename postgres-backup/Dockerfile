FROM ubuntu:stonking-20260913.1@sha256:ee126c2fa0249079a7e24ae3a3d29b04783ef93ab33c868751c9a1289d3fffff

# Install wget & gnupg2 & curl
RUN apt-get update && apt-get install -y wget gnupg2 curl

# Add Postgres libraries
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update && apt-get install -y postgresql-client

WORKDIR /opt/app

# Bundle app source
COPY . .

ENTRYPOINT ["bash", "entrypoint.sh"]
