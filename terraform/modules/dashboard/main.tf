resource "helm_release" "dashboard" {
  name             = "kubernetes-dashboard"
  repository       = "https://kubernetes.github.io/dashboard/"
  chart            = "kubernetes-dashboard"
  namespace        = "dashboard"
  create_namespace = true
  force_update     = true
  replace          = true
  atomic           = true
  set {
    name = "service.externalPort"
    value = "8080"
  }
}