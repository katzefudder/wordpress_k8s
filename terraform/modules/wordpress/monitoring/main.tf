resource "kubernetes_service_account" "service_account" {
  metadata {
    name = "highcharts-account"
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role" "monitor-role" {
  metadata {
    name = "monitor-role"
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "services", "endpoints"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "monitor-role-binding" {
  metadata {
    name = "monitor-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "monitor-role"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.service_account.metadata[0].name
    namespace = var.namespace
  }
}

resource "kubernetes_manifest" "service_monitor" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      labels = {
        jobLabels = "openresty"
        prometheus = "true"
      }
      name      = "openresty-exporter"
      namespace = var.namespace
    }
    spec = {
      selector = {
        matchLabels = {
          "app.kubernetes.io/name" = "wordpress"
        }
      }
      namespaceSelector = {
        matchNames = [
          "dev-wordpress"
        ]
      }
      endpoints = [
        {
          port = "monitoring"
        }
      ]
    }
  }
}
