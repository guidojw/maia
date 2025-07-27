FROM node:alpine@sha256:820e86612c21d0636580206d802a726f2595366e1b867e564cbc652024151e8a

RUN apk add git

WORKDIR /sharex

RUN git clone https://github.com/TannerReynolds/ShareX-Upload-Server.git ./ && \
    npm i

COPY config.json src

EXPOSE 80

CMD node src/index.js
