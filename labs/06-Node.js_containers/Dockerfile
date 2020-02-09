FROM node:10

WORKDIR /usr/src/app

COPY app/package*.json ./

RUN npm install

COPY app/ .

EXPOSE 8080

ENTRYPOINT [ "node", "server.js" ]