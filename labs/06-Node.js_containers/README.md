# Node.js containers

## Prerequisites



## Build the image

Build the image **node-web-app:1.0**

```console
$ docker build -t node-web-app:1.0 . 
Sending build context to Docker daemon   7.68kB
Step 1/7 : FROM node:10
 ---> bb78c02ca3bf
Step 2/7 : WORKDIR /usr/src/app
 ---> Using cache
 ---> 70cec91042f6
Step 3/7 : COPY app/package*.json ./
 ---> Using cache
 ---> 3d487fbde0f1
Step 4/7 : RUN npm install
 ---> Using cache
 ---> c424c4c4f3ae
Step 5/7 : COPY app/ .
 ---> 20e47e400ee4
Step 6/7 : EXPOSE 8080
 ---> Running in db7d3dc17e22
Removing intermediate container db7d3dc17e22
 ---> 6ad96fa119a3
Step 7/7 : ENTRYPOINT [ "node", "server.js" ]
 ---> Running in 78115840d5b0
Removing intermediate container 78115840d5b0
 ---> 7c387c3bf891
Successfully built 7c387c3bf891
Successfully tagged node-web-app:1.0
```

Let's see if images have been build/pulled correctly

```console
$ docker images | grep node
node-web-app                                                            1.0                        7c387c3bf891        44 seconds ago      911MB
node                                                                    10                         bb78c02ca3bf        2 days ago          908MB
```

## Run the container

Run the container i daemon mode (-d)

```console
$ docker run -p 49160:8080 -d node-web-app:1.0
53e0ddbbbaaed2fba1870317032529b913933e036af043c55bfe4ff422fc16e5
```

Get the container's standard output using `docker logs` command

```console
$ docker logs 53e0ddbbbaaed2fba1870317032529b913933e036af043c55bfe4ff422fc16e5
Running on http://0.0.0.0:8080
```

Point your browser to the docker host's IP address (in my case localhost), using the port you specified in the as an argument of `docker run` command (49160); you should see the Hello World page.

If you are using a bash terminal, you can use also `curl` command to test the container.

```console
$ curl -i localhost:49160/          
HTTP/1.1 200 OK
X-Powered-By: Express
Content-Type: text/html; charset=utf-8
Content-Length: 11
ETag: W/"b-Ck1VqNd45QIvq3AZd8XYQLvEhtA"
Date: Sun, 09 Feb 2020 15:49:07 GMT
Connection: keep-alive

Hello World```

