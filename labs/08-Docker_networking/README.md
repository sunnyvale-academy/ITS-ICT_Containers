# Docker networking

## Prerequisites

## None network model

To test the none-network model, just add the `--net none` flag to the `docker run` command as shown below.

```console
$ docker run \
    --rm \
    -it \
    --net none \
    busybox \
    ifconfig
Unable to find image 'busybox:latest' locally
latest: Pulling from library/busybox
7c9d20b9b6cd: Pull complete 
Digest: sha256:fe301db49df08c384001ed752dff6d52b4305a73a7f608f21528048e8a08b51e
Status: Downloaded newer image for busybox:latest
lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
```

The busybox container we have just run launches an `ifconfig` command, to prove there is no any other network interface a part from lo (loopback) within the container itself.

```console
$ docker run \
    --rm \
    -it \
    --net none \
    busybox \
    ifconfig
Unable to find image 'busybox:latest' locally
latest: Pulling from library/busybox
7c9d20b9b6cd: Pull complete 
Digest: sha256:fe301db49df08c384001ed752dff6d52b4305a73a7f608f21528048e8a08b51e
Status: Downloaded newer image for busybox:latest
lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
```

And also there is no network connectivity within a none network container

```console
$ docker run \
    --rm \
    -it \
    --net none \
    busybox \
    ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8): 56 data bytes
ping: sendto: Network is unreachable
```

## Bridge network model

Before testing the bridge network model, list the Docker networks created by default.

```console
$ docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
8c46c98fe79a        bridge              bridge              local
3a6f3fe18c4f        host                host                local
fd80ced7cf5a        none                null                local
```

To grab the bridge network subnet address type:

```console
$ docker network inspect bridge | grep Subnet
            "Subnet": "172.17.0.0/16"
```

If running this command on Windows, you may get an error since `grep` command is not available, just remove the `| grep Subnet` part to display the whole output.

The subnet 172.17.0.0/16 is allocated for this bridge network by default (IP Range: 172.17.0.0 – 172.17.255.255).

Let's see how many network interfaces a container has if run with `--net bridge` flag. Be aware that you run a container without the `--net bridge` flag, the same applies as a default.

```console
$ docker run \
    --rm \
    -it \
    --net bridge \
    busybox \
    ifconfig
eth0      Link encap:Ethernet  HWaddr 02:42:AC:11:00:02  
          inet addr:172.17.0.2  Bcast:172.17.255.255  Mask:255.255.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:3 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:258 (258.0 B)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
```

The **eth0** interface is a virtual interface that allows your container to communicate with the outside world, just test it:

```console
$ docker run \
    --rm \
    -it \
    --net bridge \
    busybox \
    ping 8.8.8.8
64 bytes from 8.8.8.8: seq=0 ttl=61 time=133.184 ms
64 bytes from 8.8.8.8: seq=1 ttl=61 time=14.080 ms
64 bytes from 8.8.8.8: seq=2 ttl=61 time=37.155 ms
64 bytes from 8.8.8.8: seq=3 ttl=61 time=122.273 ms
64 bytes from 8.8.8.8: seq=4 ttl=61 time=12.951 ms
64 bytes from 8.8.8.8: seq=5 ttl=61 time=30.468 ms
```

Now, let's create a new bridge network

```console
$ docker network create \
    --driver bridge \
    my_bridge_network
501a1068b17b08d9e96db8e905f559922f2d15730a9084dba9e97682f7925ac9
```

```console
$ docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
8c46c98fe79a        bridge              bridge              local
3a6f3fe18c4f        host                host                local
501a1068b17b        my_bridge_network   bridge              local
fd80ced7cf5a        none                null                local
```

The **my_bridge_network** is displayed among the others. To discover its subnet address, as before, jus type:

```console
$ docker network inspect my_bridge_network | grep Subnet
                    "Subnet": "172.18.0.0/16",
```

Fire up a new container on the default bridge network

```console
$ docker run \
    --rm \
    -d \
    --name container_1  \
    --net bridge \
    busybox \
    sleep 1000
9bff97fe17619f01b8ab372f3e3715316409b446d1624aeafe74ec276a2bae84
```

Now  start a container (container_2) attached to the new my_bridge_network

```console
$ docker run \
    --rm \
    -d \
    --name container_2  \
    --net my_bridge_network \
    busybox \
    sleep 1000
1b3ec398c29c33046d01da35b55a557a407529a19870e0d1e623fd7b8d7bfd47
```

Let's start another container (container_3) attached to my_bridge_network

```console
$ docker run \
    --rm \
    -d \
    --name container_3  \
    --net my_bridge_network \
    busybox \
    sleep 1000
e2710a77347f9486c044585c8673a8ab1cf5f92d3bd2ef76cf50ae19b3447e4b
```
As you can see, only container_2 is visible from within container_3 (they share the same bridge network):

```console
$ docker exec -ti container_3 /bin/ash
/ # ping container_2
PING container_2 (172.18.0.2): 56 data bytes
64 bytes from 172.18.0.2: seq=0 ttl=64 time=0.058 ms
64 bytes from 172.18.0.2: seq=1 ttl=64 time=0.085 ms
64 bytes from 172.18.0.2: seq=2 ttl=64 time=0.136 ms
64 bytes from 172.18.0.2: seq=3 ttl=64 time=0.077 ms
/ # ping container_1
ping: bad address 'container_1'
```

Docker has a feature which allows us to connect a container to another network.

```console
$ docker network connect bridge container_3
```


```console
$ docker exec -it container_3 ifconfig
eth0      Link encap:Ethernet  HWaddr 02:42:AC:12:00:03  
          inet addr:172.18.0.3  Bcast:172.18.255.255  Mask:255.255.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:18 errors:0 dropped:0 overruns:0 frame:0
          TX packets:10 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:1500 (1.4 KiB)  TX bytes:702 (702.0 B)

eth1      Link encap:Ethernet  HWaddr 02:42:AC:11:00:03  
          inet addr:172.17.0.3  Bcast:172.17.255.255  Mask:255.255.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:8 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:648 (648.0 B)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:8 errors:0 dropped:0 overruns:0 frame:0
          TX packets:8 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1 
          RX bytes:633 (633.0 B)  TX bytes:633 (633.0 B)
```

We can see container_3 has one extra network interface which is exactly within the range of our old bridge network.

Search for the container_1 IP address (if running this lab on Windows, just remove the `| grep -i IPAddress\" | sed -e "s/ //g" | uniq` part)

```console
$ docker inspect container_1 | grep -i IPAddress\" | sed -e "s/ //g" | uniq
"IPAddress":"172.17.0.2",
```

Try to ping container_1's IP address from the custom my_bridge_network

```console
$ docker exec -ti container_3 ping 172.17.0.2
PING 172.17.0.2 (172.17.0.2): 56 data bytes
64 bytes from 172.17.0.2: seq=0 ttl=64 time=0.089 ms
64 bytes from 172.17.0.2: seq=1 ttl=64 time=0.081 ms
64 bytes from 172.17.0.2: seq=2 ttl=64 time=0.166 ms
64 bytes from 172.17.0.2: seq=3 ttl=64 time=0.244 ms
```

It worked!

Dosconnect container_3 from the default bridge newtork

```console
$ docker network disconnect bridge container_3
```

Re-test the ping against container_1's ip address

```console
$ docker exec -ti container_3 ping 172.17.0.2
PING 172.17.0.2 (172.17.0.2): 56 data bytes
^C
--- 172.17.0.2 ping statistics ---
6 packets transmitted, 0 packets received, 100% packet loss
```

Now container_3 is unable to ping container_1 on the default bridge network.

Stop the running container.

```console
$ docker stop $(docker ps -q)
2b12864becc0
```

## Host network

```console
$ docker run \
    --rm \
    -it \
    --net host \
    busybox \
    ifconfig 
br-0b2b099ede56 Link encap:Ethernet  HWaddr 02:42:C1:C5:F8:BD  
          inet addr:172.22.0.1  Bcast:172.22.255.255  Mask:255.255.0.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

br-42e4a1643931 Link encap:Ethernet  HWaddr 02:42:B3:B9:57:F8  
          inet addr:172.25.238.1  Bcast:172.25.238.255  Mask:255.255.255.0
          inet6 addr: fe80::42:b3ff:feb9:57f8/64 Scope:Link
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:1 errors:0 dropped:0 overruns:0 frame:0
          TX packets:16 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:28 (28.0 B)  TX bytes:1220 (1.1 KiB)

br-847c610c574c Link encap:Ethernet  HWaddr 02:42:19:92:59:C9  
          inet addr:172.21.0.1  Bcast:172.21.255.255  Mask:255.255.0.0
          inet6 addr: fe80::42:19ff:fe92:59c9/64 Scope:Link
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:23 errors:0 dropped:0 overruns:0 frame:0
          TX packets:40 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:1044 (1.0 KiB)  TX bytes:2656 (2.5 KiB)

br-cdae1616570b Link encap:Ethernet  HWaddr 02:42:0C:5A:D2:13  
          inet addr:172.18.0.1  Bcast:172.18.255.255  Mask:255.255.0.0
          inet6 addr: fe80::42:cff:fe5a:d213/64 Scope:Link
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:737 errors:0 dropped:0 overruns:0 frame:0
          TX packets:779 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:1694871 (1.6 MiB)  TX bytes:402985 (393.5 KiB)

br-dd51624a0c6f Link encap:Ethernet  HWaddr 02:42:B4:4C:AA:55  
          inet addr:172.19.0.1  Bcast:172.19.255.255  Mask:255.255.0.0
          inet6 addr: fe80::42:b4ff:fe4c:aa55/64 Scope:Link
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:12 errors:0 dropped:0 overruns:0 frame:0
          TX packets:13 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:896 (896.0 B)  TX bytes:978 (978.0 B)

docker0   Link encap:Ethernet  HWaddr 02:42:0B:57:0D:73  
          inet addr:172.17.0.1  Bcast:172.17.255.255  Mask:255.255.0.0
          inet6 addr: fe80::42:bff:fe57:d73/64 Scope:Link
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:7738 errors:0 dropped:0 overruns:0 frame:0
          TX packets:27282 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:315313 (307.9 KiB)  TX bytes:38689191 (36.8 MiB)

eth0      Link encap:Ethernet  HWaddr 02:50:00:00:00:01  
          inet addr:192.168.65.3  Bcast:192.168.65.255  Mask:255.255.255.0
          inet6 addr: fe80::50:ff:fe00:1/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:281169 errors:0 dropped:0 overruns:0 frame:0
          TX packets:87061 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:402977026 (384.3 MiB)  TX bytes:4938807 (4.7 MiB)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:2543 errors:0 dropped:0 overruns:0 frame:0
          TX packets:2543 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:5320494 (5.0 MiB)  TX bytes:5320494 (5.0 MiB)
```

As you can see, a container attached to the **host network** sees every network interface installed on the host. 
 
Now we run an **nginx** container with a host network, notice that we did not map any port with the `-p` flag.

```console
$ docker run \
    --rm \
    -d \
    -it \
    --net host \
    --name nginx \
    nginx 
Unable to find image 'nginx:latest' locally
latest: Pulling from library/nginx
8d691f585fa8: Pull complete 
5b07f4e08ad0: Pull complete 
abc291867bca: Pull complete 
Digest: sha256:922c815aa4df050d4df476e92daed4231f466acc8ee90e0e774951b0fd7195a4
Status: Downloaded newer image for nginx:latest

2b12864becc0cb82761f78fe8ef77cfb8238add8935b5c2041ac8b1e91a8f00c
```

The command below will prove that the nginx container opened the 80 port directly on the host. If you don't have curl installed locally, you can point your browser [here](http://localhost:80)

```console
$ curl http://localhost:80
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

Stop the running containers.

```console
$ docker stop $(docker ps -q)
2b12864becc0
```