resource "helm_release" "loki" {
  name             = "loki"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki-stack"
  namespace        = var.namespace
  create_namespace = false
  force_update     = true
  replace          = true
  atomic           = true
}

resource "helm_release" "prometheus" {
  name             = "loki"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = var.namespace
  create_namespace = false
  force_update     = true
  replace          = true
  atomic           = true
}