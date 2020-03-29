# Containers ports

## Prerequisites

## Mapping ports on bridge network

Run a new container based on httpd (Apache webserver) image and attached to the **bridge** network

```console
$ docker run --rm -d --network bridge --name container_1 httpd:latest 
...
50fa51a075c80685849f2192e2a82026935debd02c0647ea4c440545f3c3ea9b
```

To find out what port the container is opening and exposing

```console
$ docker inspect --format='{{range $p, $conf := .Config.ExposedPorts}} {{$p}} {{end}}'  container_1  

 80/tcp 
```

Try to access the Apache default home page using cURL (I used localhost as the Docker host since Docker Desktop is running on my laptop. In the case you are using Docker Toolbox or you are dealing with a remote Docker host, please use the Docker host IP address instead).


```console
$ curl http://localhost:80/
curl: (7) Failed to connect to localhost port 80: Connection refused
```

Stop (and remove) the container.

```console
$ docker stop container_1
container_1
```

Now let's try to map the container's port on the Docker host

```console
$ docker run --rm -d -p 8080:80 --network bridge --name container_1 httpd:latest 
732d82f0c9cc6c357088c92b5d077dc8174fe12cc6f3f7d2d9c5695f3e4590c7
```

To find out what port the container is opening and exposing

```console
$ docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{( index $conf 0).HostPort}} {{end}}' container_1

 80/tcp -> 8080 
```

```console
$ curl http://localhost:8080/
<html><body><h1>It works!</h1></body></html>
```

Stop (and remove) the container.

```console
$ docker stop container_1
container_1
```

## Mapping ports on host network (!!!This demo works on Linux only!!!)

Run a new container based on httpd (Apache webserver) image and attached to the **host** network

```console
$ docker run --rm -d --network host --name container_1 httpd:latest 
...
74459a441a3e843096a4027d92fcc5b08b5d673c31c2183c4e45c994ec66f45f
```

Try to access the Apache default home page using cURL (I used localhost as the Docker host since Docker Desktop is running on my laptop. In the case you are using Docker Toolbox or you are dealing with a remote Docker host, please use the Docker host IP address instead).

```console
$ curl http://localhost/
<html><body><h1>It works!</h1></body></html>
```

In this case, even if we run the container without mapping its ports on the Docker host, all the container's port are mapped by default (and the curl command worked)

Stop (and remove) the container.

```console
$ docker stop container_1
container_1
```