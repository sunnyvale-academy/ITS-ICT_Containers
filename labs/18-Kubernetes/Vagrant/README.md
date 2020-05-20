# Kubernetes multi-node cluster with Vagrant + Virtualbox + Kubeadm

- Virtualbox + Vagrant + kubectl have to be installed on the host machine as a prerequisite (see [00-Prerequisites](../00-Prerequisites/README.md))

- Download and install **kubectl**
 from https://kubernetes.io/docs/tasks/tools/install-kubectl/ 

All the istructions here after have to be run on the host machine.

Install vagrant plugins
```console
$ vagrant plugin install vagrant-vbguest
$ vagrant plugin install vagrant-reload
$ vagrant plugin install vagrant-hostmanager
```

Provision the environent

```console
$ vagrant up
```

Test the environment

```console
$ export KUBECONFIG=kubeconfig.yaml
$ kubectl get nodes

NAME     STATUS   ROLES    AGE   VERSION
master   Ready    master   18h   v1.15.3
node1    Ready    <none>   17h   v1.15.3
node2    Ready    <none>   17h   v1.15.3
```


You need to proxy your requests to access the Dashboard

```console
vagrant$ kubectl proxy
```

Point your browser [here](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/.)
