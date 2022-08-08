resource "helm_release" "dashboard" {
  name             = "kubernetes-dashboard"
  repository       = "https://kubernetes.github.io/dashboard/"
  chart            = "kubernetes-dashboard"
  namespace        = "kube-system"
  create_namespace = true
  force_update     = true
  replace          = true
  atomic           = true
  values = [
    file("${path.module}/dashboard.yaml")
  ]
}

resource "kubernetes_service_account" "example" {
  metadata {
    name = "admin-user"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "example" {
  metadata {
    name = "admin-user"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "admin-user"
    namespace = "kube-system"
  }
}