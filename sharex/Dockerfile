FROM node:alpine@sha256:b20f8fad528b0e768936cb88ccb7b0e37cf41587d177e2d6fcdbd48bb4e083ec

RUN apk add git

WORKDIR /sharex

RUN git clone https://github.com/TannerReynolds/ShareX-Upload-Server.git ./ && \
    npm i

COPY config.json src

EXPOSE 80

CMD node src/index.js
