FROM node:alpine@sha256:be4d5e92ac68483ec71440bf5934865b4b7fcb93588f17a24d411d15f0204e4f

RUN apk add git

WORKDIR /sharex

RUN git clone https://github.com/TannerReynolds/ShareX-Upload-Server.git ./ && \
    npm i

COPY config.json src

EXPOSE 80

CMD node src/index.js
