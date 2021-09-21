# Docker + Kubernetes workshop

## login to ECR

```
docker login -u AWS -p $(aws ecr get-login-password) 859133351452.dkr.ecr.eu-west-1.amazonaws.com
```

## k8s cheatsheet

```
kubectl apply -f ../manifests/01_*.yaml
kubectl get pods
kubectl get pods -A
kubectl get pods -o wide

kubectl run alpine --image alpine:latest -i --tty -- sh
apk add curl
curl POD_IP:3000/
curl POD_IP:3000/_probe/alive
curl POD_IP:3000/_probe/ready

kubectl logs -f -l=app=backend

kubectl apply -f ../manifests/02_*.yaml
kubectl get po,ep,svc,ing
kubectl logs -f -n nginx-ingress -l=app.kubernetes.io/component=controller
curl https://backend.eks-demo.pipetail.cloud/

EXTRAS:

kubectl top pods
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl top pods
kubectl top nodes
```