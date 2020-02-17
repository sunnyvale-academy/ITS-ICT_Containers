
# Java containers

## Prerequisites:

### If building the sourcecode using a local Java installation
- Having installed [Java SE 13](https://www.oracle.com/java/technologies/javase-jdk13-downloads.html)
- $JAVA_HOME/bin must be set in $PATH


## Lab purpose

Starting from Java 8 update 131, a number of features are introduced to Java to improve getting the correct resource limits when running in a Docker containers. In this lab, I experimented these features for each Java version (8, 9 and 10) under different container configurations.

The values obtained in this lab are based on the following Docker Desktop settings:

- Memory: 2GB
- CPUs: 2


## Inspect the Java class we use in this lab

Before starting the lab, inspect the [Java class](java/DockerTest.java) we are using in this lab. It is meant to test the Java's Docker awareness in term of CPU and memory.

## Compile the Java class 

Let's compile the Java class targetting the JDK 8

Using the local JDK

```console
$ javac -nowarn -source 8 -target 8 java/DockerTest.java 
```

Or using a Docker container

```console
$ docker run --rm -v $(pwd)/java:/java openjdk:8u151 javac -nowarn -source 8 -target 8 /java/DockerTest.java 
```

## Java 8 experiment

At first we create a **docker-test:jdk8** Docker image, containing JDK 8 and our Java Class we are using as the container's entry point.


```console
$ docker build -t docker-test:jdk8 -f docker/Dockerfile.jdk8 .
Sending build context to Docker daemon  23.04kB
Step 1/3 : FROM openjdk:8u151
8u151: Pulling from library/openjdk
c73ab1c6897b: Pull complete 
1ab373b3deae: Pull complete 
b542772b4177: Pull complete 
57c8de432dbe: Pull complete 
da44f64ae999: Pull complete 
0bbc7b377a91: Pull complete 
1b6c70b3786f: Pull complete 
48010c1717c7: Pull complete 
7a6123cacadf: Pull complete 
Digest: sha256:07780244fce9b0a3b13a138adf45226372a80025c74bf81ce2bd509304d7a253
Status: Downloaded newer image for openjdk:8u151
 ---> a30a1e547e6d
Step 2/3 : COPY java/DockerTest.class /
 ---> 052eb6ed7ed8
Step 3/3 : CMD java ${JAVA_OPT} DockerTest ${APP_OPT}
 ---> Running in 50eb5022a773
Removing intermediate container 50eb5022a773
 ---> a41a4e33c76c
Successfully built a41a4e33c76c
Successfully tagged docker-test:jdk8
```

Run the class with jdk8 container.

```console
$ docker run \
        --rm \
        docker-test:jdk8

System properties
Cores       : 2
Memory (Max): 444
```
Initially, when the Java 8 container starts, it sees 2 cores and  444MB of memory (2000/4= circa 444). Now let’s try to limit the resources and see the results.

```
$ docker run \
      --rm \
      -c 512 \
      -m 512MB \
      docker-test:jdk8

System properties
Cores       : 2
Memory (Max): 444
```
Here the -c 512 sets the CPU Shares to 512, which advises using half of the available CPUs. And the -m 512MB limits the memory to given number. As expected, these arguments are not working in this Java version.

However, Java 8 update 151 has the CPU Sets improvement. This time let’s try with setting the --cpuset-cpus to a single core.

```
$ docker run \
         --rm \
         --cpuset-cpus 0 \
         -m 512MB \
         docker-test:jdk8

System properties
Cores       : 1
Memory (Max): 483
```
And it’s working. This version also allows us to use the -XX:+UseCGroupMemoryLimitForHeap option to get the correct memory limit.

```
$ docker run \
        --rm \
        --cpuset-cpus 0 \
        -m 512MB \
        -e JAVA_OPT="-XX:+UnlockExperimentalVMOptions \
        -XX:+UseCGroupMemoryLimitForHeap" \
        docker-test:jdk8

System properties
Cores       : 1
Memory (Max): 123
```
With the help of this option, finally, 123MB of heap space is allocated, which perfectly makes sense for the upper limit of 512MB.

## Java 9 experiment

Let's build an image containing the JDK 9

```console
$ docker build -t docker-test:jdk9 -f docker/Dockerfile.jdk9 .
...
Removing intermediate container cbcd8a615d7b
 ---> 5c071f9480ab
Step 6/7 : COPY java/DockerTest.class /
 ---> d1e1ccb90bc5
Step 7/7 : CMD  /jdk-9.0.4/bin/java ${JAVA_OPT} DockerTest ${APP_OPT}
 ---> Running in 992adbc9a0bc
Removing intermediate container 992adbc9a0bc
 ---> b4b568769580
Successfully built b4b568769580
Successfully tagged docker-test:jdk9
```

It would be enough to repeat the last step from the previous section since the functionality is same.

```
$ docker run \
        --rm \
        --cpuset-cpus 0 \
        -m 512MB \
        -e JAVA_OPT="-XX:+UnlockExperimentalVMOptions \
        -XX:+UseCGroupMemoryLimitForHeap" \
        docker-test:jdk9

System properties
Cores       : 1
Memory (Max): 123
```

As expected, Java 9 recognized the CPU Sets and the memory limits when -XX:+UseCGroupMemoryLimitForHeap is used.

## Java 10 experiment


Now build an image containing the JDK 10

```console
$ docker build -t docker-test:jdk10 -f docker/Dockerfile.jdk10 .
...
Removing intermediate container 18a53b00f4fd
 ---> 08fc20b8240a
Step 6/7 : COPY java/DockerTest.class /
 ---> 507c62f41298
Step 7/7 : CMD  /jdk-10/bin/java ${JAVA_OPT} DockerTest ${APP_OPT}
 ---> Running in d505757867f7
Removing intermediate container d505757867f7
 ---> 201bdb98d832
Successfully built 201bdb98d832
Successfully tagged docker-test:jdk10
```

Since Java 10 is the Docker-aware version, resource limits should have taken effect without any explicit configuration.

```
$ docker run \
         --rm \
         --cpuset-cpus 0 \
         -m 512MB \
         docker-test:jdk10

System properties
Cores       : 1
Memory (Max): 123
```

The previous snippet shows that CPU Sets are handled correctly. Now let’s try with setting CPU Shares:

```
$ docker run \
         --rm \
         -c 512 \
         -m 512MB \
         docker-test:jdk10

System properties
Cores       : 1
Memory (Max): 123
```

It’s working as expected. Also, it’s worth to see that this feature can be disabled via the -XX:-UseContainerSupport option (note that it starts with - after the -XX: prefix):

```
$ docker run \
         --rm \
         -c 512 \
         -m 512MB \
         -e JAVA_OPT=-XX:-UseContainerSupport \
         docker-test:jdk10

System properties
Cores       : 2
Memory (Max): 500
```

This time JVM reads the configuration from the Docker machine. So these outputs show how the resource limits are correctly handled in Java 10. 

## Conclusion
Even though there’re a couple of features added prior to Java 10, the newest Java release is the most container ready version experienced so far. This example  solely focused on single Docker containers. It would be good to experiment how Java 10 plays under orchestration frameworks as well (ie: Kubernetes).