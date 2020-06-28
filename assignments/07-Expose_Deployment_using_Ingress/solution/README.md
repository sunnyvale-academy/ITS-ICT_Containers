# Expose Deployment using Ingress solution

Create resources:

```console
$ kubectl apply -f .
ingress.extensions/traefik-ingress created
deployment.apps/mysql-deployment created
service/mysql-service created
clusterrole.rbac.authorization.k8s.io/traefik-ingress created
clusterrolebinding.rbac.authorization.k8s.io/traefik-ingress created
deployment.apps/traefik-ingress created
serviceaccount/traefik-ingress created
service/traefik-ingress-service created
deployment.apps/wordpress-deployment created
service/wordpress-service created
```

Open this web page http://127-0-0-1.nip.io:30605/, the Wordpress' installation page should appear.