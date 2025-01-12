FROM node:alpine@sha256:498bf3e45a4132b99952f88129ae5429e3568f3836edbfc09e3661515f620837

RUN apk add git

WORKDIR /sharex

RUN git clone https://github.com/TannerReynolds/ShareX-Upload-Server.git ./ && \
    npm i

COPY config.json src

EXPOSE 80

CMD node src/index.js
