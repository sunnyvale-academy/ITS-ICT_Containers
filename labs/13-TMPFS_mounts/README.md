# TMPFS mounts (not working on Windows)

TMPFS mount are intended to store data in an ephemeral way, meaning that when the container stops, all the data vanish.

So why not storing data within the container's RW layer? To prevent the container growing in size.

The typical data that you can afford to miss (in some situations) are the log files; let's try to store nginx log files in an TMPFS mounted volume.


## Prerequisites


## Run the container with a TMPFS-mounted volume

```console
$ docker run \
    -d \
    -p 4000:80 \
    --mount type=tmpfs,destination=/var/log/nginx \
    nginx:latest
9cb9e3039259e116a4c190b80a81be89408446fe6b89b515c6d3fbceb49832a2
```

Let's make the nginx log something

```console
$ for i in {1..50000} 
    do 
        curl -s http://localhost:4000 
    done
```

After a while, by attaching to the nginx container to run the `ls -lh` command, we get the dimension of the access.log

```console
$ docker exec 9cb9e3039259e116a4c190b80a81be89408446fe6b89b515c6d3fbceb49832a2 ls -lh /var/log/nginx/access.log
-rw-r--r-- 1 root root 411K Oct 26 14:18 /var/log/nginx/access.log
```

If you stop the container

```console
$ docker stop 9cb9e3039259e116a4c190b80a81be89408446fe6b89b515c6d3fbceb49832a2
```

And you start it over

```console
$ docker start 9cb9e3039259e116a4c190b80a81be89408446fe6b89b515c6d3fbceb49832a2
```

You will see that the dimension of the **access.log** file is 0. It means that the TMPFS-mounted volume has been discarded and recreated empty.

```console
$ docker exec 9cb9e3039259e116a4c190b80a81be89408446fe6b89b515c6d3fbceb49832a2 ls -lh /var/log/nginx/access.log
-rw-r--r-- 1 root root 0 Oct 26 14:18 /var/log/nginx/access.log
```

Finally you can stop the container

```console
$ docker stop 9cb9e3039259e116a4c190b80a81be89408446fe6b89b515c6d3fbceb49832a2
```

and remove it

```console
$ docker rm 9cb9e3039259e116a4c190b80a81be89408446fe6b89b515c6d3fbceb49832a2
```

NOTE: we used the hash **9cb9e3039259e116a4c190b80a81be89408446fe6b89b515c6d3fbceb49832a2** to reference the running container, this value is different in your environment so please change this value with yours accordingly.

