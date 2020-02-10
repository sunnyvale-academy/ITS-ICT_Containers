# Create a Redis server image

Redis is an open source (BSD licensed), in-memory data structure store, used as a database, cache and message broker. In this assignment, you will follow the Redis installation instructions here after to code a Dockerfile and build a Docker image with Redis server installed.

## Assignment requirements

- Your Redis image must be based on **ubuntu:latest** image
- Your build process has to copy the provided **redis.conf** file into the image's /etc/redis/ folder (overwiring the default config file)
- Redis server will listen for connections on port **6380/tcp**.
- On ubuntu, you can install Redis server with the commands: `apt update && apt install -y redis-server`
- The Redis command, used to start the container, is `redis-server /etc/redis/redis.conf`
- The Redis server must be run as **redis** user
- The Redis image have to be labelled with MANTAINER="your name and surname"

## Image building

After having coded the Dockerfile, you can build the image with this command

```console
$ docker build -t myredis-server:1.0 .
...
 ---> Running in f34652c9b6dc
Removing intermediate container f34652c9b6dc
 ---> 89a59dd83539
Successfully built 89a59dd83539
Successfully tagged myredis-server:1.0
```

## Run the container

Run the container in background (-d argument)

```console
$ docker run -d  -p 48391:6380 myredis-server:1.0 
3fb8ff93a165c77af8d7aeabcc1a781e50484be461440bc05faa8295678112b4
```

## Test the container

To test the container, enter into it with a bash command

```console
$ docker exec -ti 3fb8ff93a165c77af8d7aeabcc1a781e50484be461440bc05faa8295678112b4 /bin/bash
redis@3fb8ff93a165:/# redis-cli -p 6380 
127.0.0.1:6380> set messaggio ciao
OK
127.0.0.1:6380> get messaggio
"ciao"
127.0.0.1:6380> exit
```

## Cleanup

To stop the container 

```console
$ docker stop 3fb8ff93a165 
3fb8ff93a165
```

```console
$ docker rm 3fb8ff93a165 
3fb8ff93a165
```