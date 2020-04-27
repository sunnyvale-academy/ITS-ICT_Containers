# Overlay Network with Swarm

The overlay network driver creates a distributed network among multiple Docker daemon hosts. This network sits on top of (overlays) the host-specific networks, allowing containers connected to it (including swarm service containers) to communicate securely. Docker transparently handles routing of each packet to and from the correct Docker daemon host and the correct destination container.

The overlay network driver creates a distributed network among multiple Docker daemon hosts. This network sits on top of (overlays) the host-specific networks, allowing containers connected to it (including swarm service containers) to communicate securely. Docker transparently handles routing of each packet to and from the correct Docker daemon host and the correct destination container.

When you initialize a swarm or join a Docker host to an existing swarm, two new networks are created on that Docker host:

an overlay network called ingress, which handles control and data traffic related to swarm services. When you create a swarm service and do not connect it to a user-defined overlay network, it connects to the ingress network by default.
a bridge network called docker_gwbridge, which connects the individual Docker daemon to the other daemons participating in the swarm.
You can create user-defined overlay networks using docker network create, in the same way that you can create user-defined bridge networks.

## Prerequisites

Having completed labs:

- **14 - Docker Swarm**

## Create the network

Connect to the **swarmmanager** VM

```console
$ cd <GIT_REPO_NAME>/labs/14-Docker_Swarm/vagrant
$ vagrant up
$ vagrant ssh swarmmanager
vagrant@swarmmanager:~$ 
```

Create a new network of type **overlay**

```console
vagrant@swarmmanager:~$ docker network create \
  --driver overlay \
  --attachable \
  --opt encrypted \
  --subnet=172.19.0.0/16 \
  my-overlay-network
798z953vwqkb3vmk0e5dr1swo
```

Using the `--attachable` flag we create a network that can be used by standalone containers and Swarm services. Without it, only Swarm services would be using this network.

Check the new network

```console
vagrant@swarmmanager:~$ docker network ls
NETWORK ID          NAME                 DRIVER              SCOPE
d16100bc85ea        bridge               bridge              local
279100a0cf17        docker_gwbridge      bridge              local
0495856d50ba        host                 host                local
bsck9a0kyent        ingress              overlay             swarm
798z953vwqkb        my-overlay-network   overlay             swarm
8bde2a82f802        none                 null                local
```

Let's test the network by running a container attached to it from node 1.


```console
$ cd <GIT_REPO_NAME>/labs/14-Docker_Swarm/vagrant
$ vagrant ssh swarmnode1
vagrant@swarmnode1:~$ 
```

```console
vagrant@swarmnode1:~$ docker run \
    -d \
    --rm \
    --name busybox1 \
    --network my-overlay-network \
    busybox \
    sleep 1000
750177b11720c64fcb70ab4490aa385f7770a73c21ad630addcbd8ac61afc3b7
```

Discover its IP address

```console
vagrant@swarmnode1:~$ docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' busybox1
172.19.0.34
```

Disconnect from **swarmnode1** and connect to **swarmnode2**

```console
$ cd <GIT_REPO_NAME>/labs/14-Docker_Swarm/vagrant
$ vagrant ssh swarmnode2
vagrant@swarmnode2:~$ 
```

Let's try to ping busybox1 IP address (in my case 172.19.0.34) by a container on swarmnode2.

```console
vagrant@swarmnode2:~$ docker run \
    --rm \
    --name busybox2 \
    --network my-overlay-network \
    busybox \
    ping 172.19.0.34
PING 172.19.0.34 (172.19.0.34): 56 data bytes
64 bytes from 172.19.0.34: seq=0 ttl=64 time=0.584 ms
64 bytes from 172.19.0.34: seq=1 ttl=64 time=0.528 ms
64 bytes from 172.19.0.34: seq=2 ttl=64 time=0.663 ms
64 bytes from 172.19.0.34: seq=3 ttl=64 time=0.686 ms
64 bytes from 172.19.0.34: seq=4 ttl=64 time=0.851 ms
```

Despite the fact that VMs used to setup the Swarm cluster belong to subnet 192.168.135.0/24, we created an overlay network for containers with network address 172.19.0.0/16 which sits on top of it. 

Then we started two containers and attached them to our **my-overlay-network** so each one got an IP address within this subnet. 

We succeeded pinging busibox1 container's IP from busybox2 container, even if they sit on different nodes (VMs).

