# StorageClass

For a Kubernetes cluster with multiple worker nodes, the cluster admin needs to create persistent volumes that are mountable by containers running on any node and matching the capacity and access requirements in each persistent volume claim. Cloud provider managed Kubernetes clusters from IBM, Google, AWS, and others support dynamic volume provisioning. As a developer you can request a dynamic persistent volume from these services by including a storage class in your persistent volume claim.

In this lab, you will see how to dynamically create a Persitent Volume Claims on a local Kubernetes cluster.


## Discover the default storage class


```console
$ kubectl get sc          
NAME                 PROVISIONER          AGE
hostpath (default)   docker.io/hostpath   13d
```


## Test the Class with a Persistent Volume Claim

```console
$ kubectl create -f testclass-pvc.yaml 
persistentvolumeclaim/testclass-pvc created
```

Check the PVC, status must be **Bound**

```console
$ kubectl get pvc
NAME   STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
nfs    Bound    pvc-dbd16200-d7f4-4ded-a863-b1dc92af1653   1Mi        RWX            hostpath       6s
```

Check if the PV has been provisioned, status must be **Bound**

```console
$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM         STORAGECLASS   REASON   AGE
pvc-dbd16200-d7f4-4ded-a863-b1dc92af1653   1Mi        RWX            Delete           Bound    default/nfs   hostpath                11s
```

Deleting the PersistentVolumeClaim will cause the provisioner to delete the PersistentVolume and its data.

```console
$ kubectl delete -f testclass-pvc.yaml 
persistentvolumeclaim "testclass-pvc" deleted
```

```console
$ kubectl get pv
No resources found.
```

Don't forget to clean up after you:

```console
$ kubectl delete -f .
persistentvolumeclaim "nfs" deleted
```


