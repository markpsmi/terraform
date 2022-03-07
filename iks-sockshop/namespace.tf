resource "kubernetes_namespace" "SocksNS" {
  metadata {
    annotations = {
    //  name = "example-annotation"
    }

    labels = {
      "istio.io/rev"="cp-v111x.istio-system"
    }

    name = var.namespace
  }
}