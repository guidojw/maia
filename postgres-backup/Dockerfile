FROM ubuntu:cosmic-20190719@sha256:7d657275047118bb77b052c4c0ae43e8a289ca2879ebfa78a703c93aa8fd686c

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
