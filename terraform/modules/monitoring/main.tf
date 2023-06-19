data "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}