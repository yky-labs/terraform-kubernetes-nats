# (c) 2023 yky-labs
# This code is licensed under MIT license (see LICENSE for details)

locals {
  namespace = (var.create_namespace) ? kubernetes_namespace_v1.this[0].metadata[0].name : var.namespace
}

resource "kubernetes_namespace_v1" "this" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
  }
}

# https://github.com/nats-io/k8s/blob/main/helm/charts/nats/README.md

resource "helm_release" "this" {
  namespace  = local.namespace
  repository = "https://nats-io.github.io/k8s/helm/charts/"
  chart      = "nats"
  name       = var.name
  version    = var.chart_version
  values = concat([
    <<-EOF
    EOF
  ], var.chart_values)

  depends_on = [
    kubernetes_namespace_v1.this
  ]
}
