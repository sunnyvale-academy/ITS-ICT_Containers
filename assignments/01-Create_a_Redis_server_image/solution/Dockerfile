FROM ubuntu:latest

LABEL MANTAINER="Denis Maggiorotto"

USER root

RUN apt update && \
    apt install -y redis-server

EXPOSE 6380/tcp

USER redis

COPY ./redis.conf /etc/redis/redis.conf 

ENTRYPOINT ["redis-server", "/etc/redis/redis.conf"] 


## Build the image
# cd $REPO_HOME/assignments/01-Create_a_Redis_server_image
# docker build -t myredis-server:1.0 . -f ./solution/Dockerfile

## Run the container
# docker run -d  -p 48391:6380 myredis-server:1.0 