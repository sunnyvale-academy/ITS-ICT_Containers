# start from a base image
FROM node:10

# move to a specific working directory
WORKDIR /usr/src/app

# copy the package.json file to workidir
COPY app/package*.json ./

# install the app dependencies
RUN npm install

# copy the application to workdir
COPY app/ .

# let Docker (or Podman) know that this app is going to open tcp port 8080
EXPOSE 8080

# specify the container's entrypoint
ENTRYPOINT [ "node", "server.js" ]