# Docker Swarm cluster

## Prerequisites

Having completed lab **00 - Setup lab environment**

## Prepare the Sunnyvale's **swarmmanager** Ubuntu VM


Connect to the **swarmmanager** VM

```console
$ cd <GIT_REPO_NAME>/labs/14-Docker_Swarm/vagrant
$ vagrant up
$ vagrant ssh swarmmanager
vagrant@swarmmanager:~$ 
```

Initialize the **swarmmanager** VM as a Swarm Manager

```console
vagrant@swarmmanager:~$ docker swarm init --advertise-addr 192.168.135.100
Swarm initialized: current node (qif9fv9icvr4yv3fnkd1sojrk) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-13s9y4pfc3ythf8ivo334rrjuk6sqdqis73xasqjcpn2swcjjx-9f9s4g1gbosni96els2cznwwv 192.168.135.100:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

## Join Swarm nodes

Connect to the **swarmnode1** VM

```console
$ cd <GIT_REPO_NAME>/labs/14-Docker_Swarm/vagrant
$ vagrant up
$ vagrant ssh swarmnode1
vagrant@swarmnode1:~$ 
```

Type the join command as stated by the init command output.

```console
vagrant@swarmnode1:~$ docker swarm join --token SWMTKN-1-13s9y4pfc3ythf8ivo334rrjuk6sqdqis73xasqjcpn2swcjjx-9f9s4g1gbosni96els2cznwwv 192.168.135.100:2377
This node joined a swarm as a worker.
```

Connect to the **swarmnode2** VM

```console
$ cd <GIT_REPO_NAME>/labs/14-Docker_Swarm/vagrant
$ vagrant up
$ vagrant ssh swarmnode2
vagrant@swarmnode2:~$ 
```

Repeat the join command on swarmnode2 host

```console
vagrant@swarmnode2:~$ docker swarm join --token SWMTKN-1-13s9y4pfc3ythf8ivo334rrjuk6sqdqis73xasqjcpn2swcjjx-9f9s4g1gbosni96els2cznwwv 192.168.135.100:2377
This node joined a swarm as a worker.
```

## Verify the cluster status

Connect to the **swarmmanager** VM

```console
$ cd <GIT_REPO_NAME>/labs/14-Docker_Swarm/vagrant
$ vagrant up
$ vagrant ssh swarmmanager
vagrant@swarmmanager:~$ 
```

Verify the cluster status

```console
vagrant@swarmmanager:~$ docker node ls
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
qif9fv9icvr4yv3fnkd1sojrk *   swarmmanager        Ready               Active              Leader              18.09.7
tqg73hvlo64usbkzhsmeypmgj     swarmnode1          Ready               Active                                  18.09.7
lml1y61ktp2ltmt1m1a0awl0a     swarmnode2          Ready               Active                                  18.09.7
```

## Schedule a Service

Now that we have our swarm up and running, it is time to schedule our containers on it.

All we are going to do is tell the manager to run the containers for us and it will take care of scheduling out the containers, sending the commands to the nodes and distributing it.

```console
vagrant@swarmmanager:~$ docker service create --replicas 5 -p 4000:80 --name web nginx
ti0272mum77o8f6sdlglrzyp7
overall progress: 5 out of 5 tasks 
1/5: running   [==================================================>] 
2/5: running   [==================================================>] 
3/5: running   [==================================================>] 
4/5: running   [==================================================>] 
5/5: running   [==================================================>] 
verify: Service converged
```

```console
vagrant@swarmmanager:~$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
ti0272mum77o        web                 replicated          5/5                 nginx:latest        *:4000->80/tcp
```

When you access port 4000 on any node, Docker routes your request to an active container. On the swarm nodes themselves, port 4000 may not actually be bound, but the routing mesh knows how to route the traffic and prevents any port conflicts from happening.


```console
vagrant@swarmmanager:~$ curl swarmnode1:4000
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


```console
vagrant@swarmmanager:~$ docker service scale web=50
verify: Service converged 
```


Finally, stop/delete the service to preserve computational resources.


```console
vagrant@swarmmanager:~$ docker service rm web
web
```
