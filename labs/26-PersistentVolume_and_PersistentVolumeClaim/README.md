# PersistentVolume and PersistentVolumeClaim

A persistent volume (PV) is a cluster-wide resource that you can use to store data in a way that it persists beyond the lifetime of a pod. The PV is not backed by locally-attached storage on a worker node but by networked storage system such as EBS or NFS or a distributed filesystem like Ceph.

## Create a NFS server Pod 

```console
$ kubectl create -f nfs-server.yaml
service/nfs-server created
deployment.apps/nfs-server created
```

## NFS persistent volume

Type the following to create the PV.

```console
$ kubectl create -f nfs-volume.yaml
persistentvolume/nfsvol created
```

Let's check to see if it is available

```console
$ kubectl get pv
NAME     CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
nfsvol   5Gi        RWX            Retain           Available                                   8s                                   52s
```

In order to use a PV you need to claim it first, using a persistent volume claim (PVC). The PVC requests a PV with your desired specification (size, speed, etc.) from Kubernetes and binds it then to a pod where you can mount it as a volume. 


```console
$ kubectl create -f pvc.yaml
persistentvolumeclaim/nfs-pvc created
```

Now verify if the PVC is marked as **Bound**

```console
$ kubectl get pvc -o wide
NAME      STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE   VOLUMEMODE
nfs-pvc   Bound    nfsvol   5Gi        RWX            manual         44s   Filesystem
```

The Pod we are going to create is made of an nginx container that mounts the volume to use it as a document root

```console
$ kubectl create -f nginx-pod.yaml
pod/nginx-nfs-pod created  
service/nginx-nodeport-service created
```

As you can see in the output, nginx-pod.yaml also contains the declaration of a NodePort Service to let you access the webserver on port 30100.

After a few minutes, verify that the pod was created:

```console
$ kubectl get pods
NAME            READY   STATUS    RESTARTS   AGE
nginx-nfs-pod   1/1     Running   0          2m21s
```

Let's create a couple of pods that are using the same PV

```console
$ kubectl apply -f busybox-deployment.yaml
deployment.apps/busybox-nfs-deployment created
```
Verify if all the busybox pod replicas have been created correctly, also they should have been scheduled on both nodes.

```console
$ kubectl get pods -o wide
NAME                                      READY   STATUS    RESTARTS   AGE    IP            NODE    NOMINATED NODE   READINESS GATES
busybox-nfs-deployment-7f748f7b9c-2kgs4   1/1     Running   0          95s    10.1.0.114   docker-desktop   <none>           <none>
busybox-nfs-deployment-7f748f7b9c-5zk5r   1/1     Running   0          95s    10.1.0.115   docker-desktop   <none>           <none>
nfs-server-848cb6f6fc-rj9mz               1/1     Running   0          14m    10.1.0.112   docker-desktop   <none>           <none>
nginx-nfs-pod                             1/1     Running   0          4m9s   10.1.0.113   docker-desktop   <none>           <none>
```

If you point your browser [here](http://localhost:30100) and keep refreshing the window, you should see that every 5 seconds a new entry is appended at the bottom of the page. An entry is made of the pod's hostname and a timestamp. 

What is happening here is that the two busybox pods are writing the same file in the same volume. Also, the nginx pod is mounting the same volume to read the file and present it to you.

Don't forget to clean up after you:

```console
$ kubectl delete -f .
deployment.apps "busybox-nfs-deployment" deleted
service "nfs-server" deleted
deployment.apps "nfs-server" deleted
persistentvolume "nfsvol" deleted
pod "nginx-nfs-pod" deleted
service "nginx-nodeport-service" deleted
persistentvolumeclaim "nfs-pvc" deleted
```


