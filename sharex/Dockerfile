FROM node:alpine@sha256:0a29d8a047149079bf48dab598f287815e39867d547e8f3935cfdece0a4379cc

RUN apk add git

WORKDIR /sharex

RUN git clone https://github.com/TannerReynolds/ShareX-Upload-Server.git ./ && \
    npm i

COPY config.json src

EXPOSE 80

CMD node src/index.js
