resource "helm_release" "socks-demo" {
  name = "socks-demo"
  chart = "./helm-chart"
  namespace = var.namespace
  create_namespace = false
  timeout = 600

//set {
 // name = "opencartHost"
 // value = "benoc.milab.local"
//}
 /* set {
    name = "opencartUsername"
    value= "admin"
  }
  set {
    name = "opencartPassword"
    value = "password"
  }
  set {
    name = "mariadb\\.auth\\.rootPassword"
    value = "secretpassword"
  }
*/
depends_on = [kubernetes_namespace.SocksNS]

}