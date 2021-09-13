resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  namespace        = "nginx-ingress"
  create_namespace = true

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  values = [
    "${file("assets/nginx-ingress.values.yaml")}"
  ]
}