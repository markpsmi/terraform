output "LoadBalancerDNS" {
  value = data.kubernetes_service.socks-lb.status[0].load_balancer[0].ingress[0].hostname
}

