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
kubectl delete po backend-*

kubectl get pods -o wide
kubectl delete -f ../manifests/01_*.yaml
kubecyl apply -f ../manifests/01_*.yaml
kubectl scale --replicas 2 deploy/backend
kubectl scale --replicas 4 deploy/backend
kubectl edit deploy/backend

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

kubectl apply -f ../manifests/03_*.yaml
kubectl top pods
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl top pods
kubectl top nodes

kubectl apply -f ../manifests/04_*.yaml
watch kubectl get po

kubectl apply -f ../manifests/05_*.yaml
kubectl get pdb

kubectl apply -f ../manifests/06_*.yaml
kubectl rollout status deploy/backend -w

```