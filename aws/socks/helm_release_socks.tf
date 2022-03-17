resource "helm_release" "socks-demo" {
  name = "socks-demo"
  chart = "./helm-chart"
  namespace = "socks"
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
}