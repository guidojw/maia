FROM ubuntu:stonking-20260705@sha256:694b773ee7e0d0b55ca74c095ac3309055589e7cbfaf3100f0b226c38c6936fa

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
