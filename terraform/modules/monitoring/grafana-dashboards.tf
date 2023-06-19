resource kubernetes_config_map_v1 "grafana-dashboards" {
  metadata {
    name = "grafana-dashboards"
    labels = {
      "grafana_dashboard" = "1"
    }
    namespace = data.kubernetes_namespace.monitoring.metadata[0].name
  }

  data = {
    "loki.json" = file("${path.module}/config/dashboards/loki.json")
  }
}