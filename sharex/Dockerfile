FROM node:alpine@sha256:8996bb5821d62a8fd9bb27c1cb07462f3fdce6e47d640c6a881ead0b064ce216

RUN apk add git

WORKDIR /sharex

RUN git clone https://github.com/TannerReynolds/ShareX-Upload-Server.git ./ && \
    npm i

COPY config.json src

EXPOSE 80

CMD node src/index.js
