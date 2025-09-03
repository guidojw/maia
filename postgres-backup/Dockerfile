FROM ubuntu:questing-20250830@sha256:a61c057b4f69200ecf031519a20db79b8683837ba1dc2a59458d333eb75b174d

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
