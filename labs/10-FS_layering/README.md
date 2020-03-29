# FS layering

## Prerequisites

## Play with Docker layers

Each container is an image with a readable/writeable layer on top of a bunch of read-only layers.

These layers (also called intermediate images) are generated when the commands in the Dockerfile are executed during the Docker image build.

For example, here is a Dockerfile for creating a node.js web app image. It shows the commands that are executed to create the image.

```Dockerfile
FROM node:argon
# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
# Install app dependencies
COPY app /usr/src/
RUN npm install
# Bundle app source
COPY . /usr/src/app
EXPOSE 8080
CMD [ "npm", "start" ]
```

Shown below, when Docker builds the container from the above Dockerfile, each step corresponds to a command run in the Dockerfile. And each layer is made up of the file generated from running that command. Along with each step, the layer created is listed represented by its random generated ID.

```console
$ docker build -f Dockerfile.base -t expressweb .

Sending build context to Docker daemon   12.8kB
Step 1/8 : FROM node:argon
 ---> ef4b194d8fcf
Step 2/8 : RUN mkdir -p /usr/src/app
 ---> Using cache
 ---> e32196f41321
Step 3/8 : WORKDIR /usr/src/app
 ---> Using cache
 ---> 115c22d70789
Step 4/8 : COPY app /usr/src/
 ---> Using cache
 ---> 468a0ad4df48
Step 5/8 : RUN npm install
 ---> Using cache
 ---> 36d9a21fb28c
Step 6/8 : COPY . /usr/src/app
 ---> Using cache
 ---> 759b04e25fb3
Step 7/8 : EXPOSE 8080
 ---> Using cache
 ---> b2138e596dcf
Step 8/8 : CMD [ "npm", "start" ]
 ---> Using cache
 ---> 05e78621f26f
Successfully built 05e78621f26f
Successfully tagged expressweb:latest
```

Once the image is built, you can view all the layers that make up the image with the docker history command. The “Image” column (i.e intermediate image or layer) shows the randomly generated UUID that correlates to that layer.

```console
$ docker history expressweb
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
05e78621f26f        About a minute ago   /bin/sh -c #(nop)  CMD ["npm" "start"]          0B                  
b2138e596dcf        About a minute ago   /bin/sh -c #(nop)  EXPOSE 8080                  0B                  
759b04e25fb3        About a minute ago   /bin/sh -c #(nop) COPY dir:84ce25be70d5ceed9…   6.3kB               
36d9a21fb28c        About a minute ago   /bin/sh -c npm install                          6.11MB              
468a0ad4df48        2 minutes ago        /bin/sh -c #(nop) COPY dir:3abf2518341487803…   578B                
115c22d70789        22 minutes ago       /bin/sh -c #(nop) WORKDIR /usr/src/app          0B                  
e32196f41321        22 minutes ago       /bin/sh -c mkdir -p /usr/src/app                0B                  
ef4b194d8fcf        23 months ago        /bin/sh -c #(nop)  CMD ["node"]                 0B                  
<missing>           23 months ago        /bin/sh -c set -ex   && for key in     6A010…   4.44MB              
<missing>           23 months ago        /bin/sh -c #(nop)  ENV YARN_VERSION=1.5.1       0B                  
<missing>           23 months ago        /bin/sh -c ARCH= && dpkgArch="$(dpkg --print…   36.8MB              
<missing>           23 months ago        /bin/sh -c #(nop)  ENV NODE_VERSION=4.9.1       0B                  
<missing>           23 months ago        /bin/sh -c set -ex   && for key in     94AE3…   129kB               
<missing>           23 months ago        /bin/sh -c groupadd --gid 1000 node   && use…   335kB               
<missing>           23 months ago        /bin/sh -c set -ex;  apt-get update;  apt-ge…   320MB               
<missing>           23 months ago        /bin/sh -c apt-get update && apt-get install…   123MB               
<missing>           23 months ago        /bin/sh -c set -ex;  if ! command -v gpg > /…   0B                  
<missing>           23 months ago        /bin/sh -c apt-get update && apt-get install…   41.2MB              
<missing>           23 months ago        /bin/sh -c #(nop)  CMD ["bash"]                 0B                  
<missing>           23 months ago        /bin/sh -c #(nop) ADD file:3e6141c0c9cb74b14…   127MB 
```

An image becomes a container when the `docker run` command is executed.

The container has a writeable layer that stacks on top of the image layers. This writeable layer allows you to “make changes” to the container since the lower layers in the image are read-only.

Where are the layers found?
To dig down into each layer of the image and view its contents you need to view the layers on the Docker host at:
/var/lib/docker/\<storage-driver\> (\<storage-driver\> can be overlay2, aufs)

If we try to extend the previous image

```console
$ docker build -f Dockerfile.extending -t extending-expressweb .
Sending build context to Docker daemon  12.29kB
Step 1/2 : FROM expressweb
 ---> 05e78621f26f
Step 2/2 : CMD [ "npm", "start" ]
 ---> Running in 2f7ebfb5c089
Removing intermediate container 2f7ebfb5c089
 ---> 89225b48bf26
Successfully built 89225b48bf26
Successfully tagged extending-expressweb:latest
```

```console
$ docker history extending-expressweb
89225b48bf26        About a minute ago   /bin/sh -c #(nop)  CMD ["npm" "start"]          0B                  
05e78621f26f        7 minutes ago        /bin/sh -c #(nop)  CMD ["npm" "start"]          0B                  
b2138e596dcf        7 minutes ago        /bin/sh -c #(nop)  EXPOSE 8080                  0B                  
759b04e25fb3        7 minutes ago        /bin/sh -c #(nop) COPY dir:84ce25be70d5ceed9…   6.3kB               
36d9a21fb28c        8 minutes ago        /bin/sh -c npm install                          6.11MB              
468a0ad4df48        8 minutes ago        /bin/sh -c #(nop) COPY dir:3abf2518341487803…   578B                
115c22d70789        28 minutes ago       /bin/sh -c #(nop) WORKDIR /usr/src/app          0B                  
e32196f41321        28 minutes ago       /bin/sh -c mkdir -p /usr/src/app                0B                  
ef4b194d8fcf        23 months ago        /bin/sh -c #(nop)  CMD ["node"]                 0B                  
<missing>           23 months ago        /bin/sh -c set -ex   && for key in     6A010…   4.44MB              
<missing>           23 months ago        /bin/sh -c #(nop)  ENV YARN_VERSION=1.5.1       0B                  
<missing>           23 months ago        /bin/sh -c ARCH= && dpkgArch="$(dpkg --print…   36.8MB              
<missing>           23 months ago        /bin/sh -c #(nop)  ENV NODE_VERSION=4.9.1       0B                  
<missing>           23 months ago        /bin/sh -c set -ex   && for key in     94AE3…   129kB               
<missing>           23 months ago        /bin/sh -c groupadd --gid 1000 node   && use…   335kB               
<missing>           23 months ago        /bin/sh -c set -ex;  apt-get update;  apt-ge…   320MB               
<missing>           23 months ago        /bin/sh -c apt-get update && apt-get install…   123MB               
<missing>           23 months ago        /bin/sh -c set -ex;  if ! command -v gpg > /…   0B                  
<missing>           23 months ago        /bin/sh -c apt-get update && apt-get install…   41.2MB              
<missing>           23 months ago        /bin/sh -c #(nop)  CMD ["bash"]                 0B                  
<missing>           23 months ago        /bin/sh -c #(nop) ADD file:3e6141c0c9cb74b14…   127MB 
```

All the layers of **extending-expressweb** image are the same of **expressweb**, except the last (89225b48bf26) that has been added in the **Dockerfile.extending**. 

BE AWARE: image layer IDs are randomly defined, in your lab they will be diffetent than mine.


```console
$ docker images | grep -E 'REPOSITORY|express'                            
REPOSITORY                                                              TAG                        IMAGE ID            CREATED             SIZE
extending-expressweb                                                    latest                     89225b48bf26        9 minutes ago       659MB
expressweb                                                              latest                     05e78621f26f        15 minutes ago      659MB
```

Both images weight 659MB, but since layers are all the same (same IDs), instead of 659 x 2 the occupied disk space is only 659MB (the images share the RO layers). 

```console
$ docker run -d -p 8080:8080 --rm --name extending-expressweb-container -ti extending-expressweb 

5d20af9b7fdcdec491470522b1f70f315b8d4601d380e66e579b1a5e5661120f
```


```console
$ docker ps -s | grep -E 'IMAGE|extending-expressweb-container'     
CONTAINER ID        IMAGE                  COMMAND             CREATED              STATUS              PORTS                    NAMES                            SIZE   
5d20af9b7fdc        extending-expressweb   "npm start"         About a minute ago   Up About a minute   0.0.0.0:8080->8080/tcp   extending-expressweb-container   0B (virtual 659MB)
```

- **size** is the size on disk for the writable layer of the container; all data written in the container is stored there, and this is not shared between containers
- **virtual size** is the size of the "read-only" layer (the image that the container was started from) plus the size of the writable layer (size).

```console
$ docker stop extending-expressweb-container
extending-expressweb-container
```