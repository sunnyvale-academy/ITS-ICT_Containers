# Volumes

## Prerequisites


## Create a volume

To create a volume type the following command

```console
$ docker volume create my-vol
my-vol
```

Now list the volumes, you should find yours

```console
$ docker volume ls
DRIVER              VOLUME NAME
local               my-vol
```

To gather informations about the volume:

```console
$ docker volume inspect my-vol
[
    {
        "CreatedAt": "2019-10-26T09:07:31Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/my-vol/_data",
        "Name": "my-vol",
        "Options": {},
        "Scope": "local"
    }
]
```

## Use the volume

Now start a new **nginx:latest** container, mounting the volume in the path where Nginx stores the document root (/usr/share/nginx/html)

```console
$ docker run -d \
    --name=nginxtest \
    --mount source=my-vol,destination=/usr/share/nginx/html \
    nginx:latest 
a52c0d80c11dc8d62f6abfcdb896714aaa05417a4163ce0e210bbcdd22c8657b
```

Doing this way, the container copied the content of /usr/share/nginx/html folder into the volume.

If you list the content of the volume using another container, you can find the application's files now.

```console
$ docker run --rm -v my-vol:/app busybox ls -l /app
total 8
-rw-r--r--    1 root     root           494 Mar  3 14:32 50x.html
-rw-r--r--    1 root     root           612 Mar  3 14:32 index.html
```

## Delete the volume

Try to delete the volume

```console
$ docker volume rm my-vol
Error response from daemon: remove my-vol: volume is in use - [a52c0d80c11dc8d62f6abfcdb896714aaa05417a4163ce0e210bbcdd22c8657b]
```

Stop the container

```console
$ docker stop a52c0d80c11dc8d62f6abfcdb896714aaa05417a4163ce0e210bbcdd22c8657b
a52c0d80c11dc8d62f6abfcdb896714aaa05417a4163ce0e210bbcdd22c8657b
```

Delete the container

```console
$ docker rm a52c0d80c11dc8d62f6abfcdb896714aaa05417a4163ce0e210bbcdd22c8657b
a52c0d80c11dc8d62f6abfcdb896714aaa05417a4163ce0e210bbcdd22c8657b
```

Try to remove the volume again

```console
$ docker volume rm my-vol
my-vol
```


