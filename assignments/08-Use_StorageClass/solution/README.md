# Use Storage Class solution

Create resources

```console
$ kubectl apply -f .
deployment.apps/mysql-deployment configured
persistentvolumeclaim/mysql-pvc created
```

Check PVC, PV and Deployment


```console
$ kubectl get pvc
NAME        STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
mysql-pvc   Bound    pvc-d0417c4a-cf85-4a0a-99a7-b70d5c6f5da5   100Mi      RWO            hostpath       7s
```


```console
$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM               STORAGECLASS   REASON   AGE
pvc-d0417c4a-cf85-4a0a-99a7-b70d5c6f5da5   100Mi      RWO            Delete           Bound    default/mysql-pvc   hostpath                25s
```

```console
$ kubectl describe deployment mysql-deployment
Name:                   mysql-deployment
Namespace:              default
CreationTimestamp:      Mon, 29 Jun 2020 00:15:53 +0200
Labels:                 name=mysql-deployment
Annotations:            deployment.kubernetes.io/revision: 2
                        kubectl.kubernetes.io/last-applied-configuration:
                          {"apiVersion":"apps/v1","kind":"Deployment","metadata":{"annotations":{},"labels":{"name":"mysql-deployment"},"name":"mysql-deployment","n...
Selector:               app=mysql-pod
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=mysql-pod
  Containers:
   mysql:
    Image:      mysql:5.6
    Port:       3306/TCP
    Host Port:  0/TCP
    Environment:
      MYSQL_ROOT_PASSWORD:  wordpress
      MYSQL_DATABASE:       wordpress
      MYSQL_USER:           wordpress
      MYSQL_PASSWORD:       wordpress
    Mounts:
      /var/lib/mysql from mysql-volume (rw)
  Volumes:
   mysql-volume:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  mysql-pvc
    ReadOnly:   false
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   mysql-deployment-85888b7b5 (1/1 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  6m1s  deployment-controller  Scaled up replica set mysql-deployment-b587958c5 to 1
  Normal  ScalingReplicaSet  100s  deployment-controller  Scaled up replica set mysql-deployment-85888b7b5 to 1
  Normal  ScalingReplicaSet  96s   deployment-controller  Scaled down replica set mysql-deployment-b587958c5 to 0
```