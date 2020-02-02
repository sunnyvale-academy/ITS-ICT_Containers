# Docker images and containers

## Prerequisites

Having installed Docker as showed in [lab 03](../03-Docker_installation/README.md)

Having a valid Docker Hub account, if needed you can subscribe [here](https://hub.docker.com)

## Build an image

Modify the Dockerfile to reflect your name and surname (change <NOME> <COGNOME> placeholders accordingly)

Build the Docker image

```console
$ docker build -t hello-new-image:1.0 .
Sending build context to Docker daemon  2.048kB
Step 1/2 : FROM ubuntu:15.04
 ---> d1b55fd07600
Step 2/2 : CMD echo "Hello new image!"
 ---> Running in d47bf5daca6c
Removing intermediate container d47bf5daca6c
 ---> 080d4c508a92
Successfully built 080d4c508a92
Successfully tagged hello-new-image:1.0
```

List the images

```console
$ docker images
REPOSITORY                  TAG        IMAGE ID            CREATED              SIZE
ubuntu                      15.04      d1b55fd07600        4 years ago          131MB
hello-new-image             1.0        080d4c508a92        About a minute ago   131MB
```

## Run a container

Now run a container based on your image

```console
$ docker run hello-new-image:1.0
Hello by Denis Maggiorotto!
```


## Share your image on Docker Hub

Tag your image specifying your Docker Hub username before the image name (change the **\<docker hub username\>** placeholder accordingly)

```console
$ docker tag hello-new-image:1.0 <docker hub username>/hello-new-image:1.0
```

Login to Docker Hub

```console
$ docker login
Login Succeeded
```

Push the image (change the **\<docker hub username\>** placeholder accordingly)

```console
$ docker push <docker hub username>/hello-new-image:1.0 
The push refers to repository [docker.io/dennydgl1/hello-new-image]
5f70bf18a086: Mounted from lorel/docker-stress-ng
ed58a6b8d8d6: Pushed
84cc3d400b0d: Pushed
3cbe18655eb6: Pushed
1.0: digest: sha256:11d580acb582a49a9b21ff746b28cfd2ebc33fe83c4113667f8017a0d373d341 size: 1149
```

## Run a container based on your collegue's image

Run a container based on your colleque image (change the **\<docker hub username\>** placeholder accordingly)

```console
$ docker run <docker hub username>/hello-new-image:1.0
Hello by Mario Rossi!
```



