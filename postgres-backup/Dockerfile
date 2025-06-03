FROM ubuntu:questing-20250601@sha256:dd397d3b5e4896054db111cb5145c0c08a6e7a669537e750e79e0385f2d69207

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
