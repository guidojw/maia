FROM node:alpine@sha256:6f08a523443ddedf52941874c203475b0ad503e859ad70cb26ab8be9a517dbd5

RUN apk add git

WORKDIR /sharex

RUN git clone https://github.com/TannerReynolds/ShareX-Upload-Server.git ./ && \
    npm i

COPY config.json src

EXPOSE 80

CMD node src/index.js
