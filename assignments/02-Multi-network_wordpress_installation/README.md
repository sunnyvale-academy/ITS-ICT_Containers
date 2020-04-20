
## Multi-network wordpress installation

**Task 1)** Create two different networks called **frontend** and **backend**

**Task 2)** Run the MySQL (database) container attached to the backend network

__BE AWARE__, when you run a container, the `docker run` command supports only ONE `--net` flag. 
If you want to connect a container with multiple networks, after having created it you can use the command `docker network connect <NETWORK> <CONTAINER>`

```console
$ docker run \
    --name mysql \
    -e MYSQL_ROOT_PASSWORD=somewordpress \
    -e MYSQL_DATABASE=wordpress \
    -e MYSQL_USER=wordpress \
    -e MYSQL_PASSWORD=wordpress \
    --net backend \
    -d \
    mysql:5.7
```

**-d** runs your container in background

**Task 3)** Run the Workdpress container attached to the frontend network 

__BE AWARE__, when you run a container, the `docker run` command supports only ONE `--net` flag. 
If you want to connect a container with multiple networks, after having created it you can use the command `docker network connect <NETWORK> <CONTAINER>`

```console
$ docker run \
    --name wordpress \
    -e WORDPRESS_DB_HOST=mysql:3306 \
    -e WORDPRESS_DB_USER=wordpress \
    -e WORDPRESS_DB_PASSWORD=wordpress \
    -e WORDPRESS_DB_NAME=wordpress \
    -d \
    -p "8000:80" \
    --net frontend \
    wordpress
```

**-d** runs your container in background

The two containers do not communicate to each other since they are on different networks.

**Task 4)** Do everithing is needed to let the wordpress container (frontend) communicate with mysql container (backend).

**Task 5)** Point your browser to [http://localhost:8000](http://localhost:8000), you should see the Workdpress installation page. Go ahead in the wizard and perform the Wordpress installation (this should prove the wordpress container communication with mysql one).

If you are using Docker toolbox, change the URL http://localhost:8000 with http://\<YOUR DOCKER MACHINE IP ADDRESS\>:8000


