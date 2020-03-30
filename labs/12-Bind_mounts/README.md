# Bind mounts

We will use a bind mount to compile a Java application, even without having a JDK installed!

## Prerequisites


## Create a container to compile the source code

Here we create a container used to compile the Java source code (Main.java). 
Note the `-v` flag used to mount a host's directory with the source code into the container.

```console
$ docker run \
    --rm \
    -v $(pwd)/app:/app/ \
    openjdk:7 javac -cp /app /app/Main.java
```

Now, if you list the host's directory content, you will see the Java compiled bytecode.

```console
$ ls -l app | grep class
-rw-r--r-- 1 denismaggiorotto staff 428 Oct 26 13:06 Main.class
```

## Create a container to run the byte code

We can also run the Java class using the same image, but with a different container

```console
$ docker run \
    --rm \
    -v $(pwd)/app:/app/ \
    openjdk:7 java -cp / app.Main
Hello from a Java app!
```

NOTE: We do not have any JDK or JVM installed on the Docker Host (docker-vm)!

We used a bind mount to perform some operation with the container on a directory coming from the Docker host.

PAY ATTENTION when using bind mounts, if you perform a bad operation within the mount point, you can affect data on your Docker Host machine.

# RedOnly bind mounts

To make the bind mount read-only, 

```console
$ docker run \
    --rm \
    --mount type=bind,source=$(pwd)/app,target=/app/,readonly \
    openjdk:7 java -cp / app.Main
Hello from a Java app!
```



