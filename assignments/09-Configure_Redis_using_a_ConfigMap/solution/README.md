# Configure Redis using a ConfigMap

To apply the solution

```console
$ kubectl apply -f . 
configmap/redis-config-map created
deployment.apps/redis-deployment created
service/redis-service created
```

To test the solution 

```console
$ kubectl run -i --rm --tty redis --image=redis --restart=Never -- redis-cli -h redis-service -p 6380 ping
PONG
pod "redis" deleted
```

To clean after you

```console
$ kubectl delete -f .
configmap "redis-config-map" deleted
deployment.apps "redis-deployment" deleted
service "redis-service" deleted
```
