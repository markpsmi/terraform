output "k8s_cluster_moid" {
  value = module.iks_cluster.k8s_cluster_moid
}
  
#data "intersight_kubernetes_cluster" "deployedcluster" {
 # moid = intersight_kubernetes_cluster_profile.deployaction.associated_cluster.0.moid
#}
  
#output "k8s_cluster_kubeconfig" {
 # value = data.intersight_kubernetes_cluster.deployedcluster.results.0.kube_config
#} 
