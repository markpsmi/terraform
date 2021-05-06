############################################################
# ADD THIRD PARTY PROVIDERS
############################################################
terraform {
  required_providers {
    intersight = {
      source = "CiscoDevNet/intersight"
      version = "=1.0.5"
    }
  }
}

provider "intersight" {
  apikey        = var.api_key_id
  secretkey     = var.api_private_key
  endpoint      = var.api_endpoint
}
############################################################
# GET ORGANIZATION MOID
############################################################
data "intersight_organization_organization" "organization" {
  name = var.org
}


############################################################
# GET K8S VERSION MOID
############################################################
data "intersight_kubernetes_version" "version" {
  kubernetes_version = join("", ["v", var.k8s_version])
}


############################################################
# CREATE K8S VERSION POLICY
############################################################
resource "intersight_kubernetes_version_policy" "version" {
  
  name = "${var.cluster_name}_version"

  nr_version {
    object_type = "kubernetes.Version"
    moid        = data.intersight_kubernetes_version.version.results[0].moid
  }

  organization {
    object_type = "organization.Organization"
    moid        = data.intersight_organization_organization.organization.results[0].moid
  }
}


############################################################
# CREATE K8S SYS CONFIG POLICY
############################################################
resource "intersight_kubernetes_sys_config_policy" "k8s_sysconfig" {

  name = "${var.cluster_name}_sysconfig"

  dns_servers = var.dns_servers

  ntp_servers = var.ntp_servers
  timezone    = var.timezone

  organization {
    object_type = "organization.Organization"
    moid        = data.intersight_organization_organization.organization.results[0].moid
  }
}


############################################################
# CREATE K8S NETWORK POLICY
############################################################
resource "intersight_kubernetes_network_policy" "k8s_network" {

  name = "${var.cluster_name}_network"

  pod_network_cidr = var.pod_network_cidr
  service_cidr     = var.service_cidr

  organization {
    object_type = "organization.Organization"
    moid        = data.intersight_organization_organization.organization.results[0].moid
  }
}


############################################################
# CREATE K8S CONTAINER RUNTIME POLICY
############################################################
resource "intersight_kubernetes_container_runtime_policy" "k8s_runtime" {

  name = "${var.cluster_name}_runtime"
  
  count = var.proxy_enabled ? 1 : 0

  docker_http_proxy {
    protocol = var.http_proxy_protocol
    hostname = var.http_proxy_hostname
    port     = var.http_proxy_port
  }

  docker_https_proxy {
    protocol = var.https_proxy_protocol
    hostname = var.https_proxy_hostname
    port     = var.https_proxy_port
  }

  organization {
    object_type = "organization.Organization"
    moid        = data.intersight_organization_organization.organization.results[0].moid
  }
}


############################################################
# CREATE K8S NODE TYPE POLICY
############################################################
resource "intersight_kubernetes_virtual_machine_instance_type" "nodetype" {

  name = "${var.cluster_name}_nodetype"

  cpu = var.cpu
  memory = var.memory
  disk_size = var.disk_size

  organization {
    object_type = "organization.Organization"
    moid        = data.intersight_organization_organization.organization.results[0].moid
  }
}


############################################################
# GET VCENTER MOID
############################################################
data "intersight_asset_target" "infra_target" {
  name = var.vcenter_target
}


############################################################
# CREATE K8S INFRA PROVIDER POLICY
############################################################
resource "intersight_kubernetes_virtual_machine_infra_config_policy" "infra_policy" {
  name = "${var.cluster_name}_infrapolicy"
  
  vm_config {
    object_type = "kubernetes.EsxiVirtualMachineInfraConfig"
    interfaces  = var.vcenter_network
    additional_properties = jsonencode({
      Datastore    = var.vcenter_datastore
      Cluster      = var.vcenter_cluster
      Passphrase   = var.vcenter_passphrase
    })
  }
  
  target {
    object_type = "asset.DeviceRegistration"
    moid        = data.intersight_asset_target.infra_target.results[0].registered_device[0].moid
  }
  
  organization {
    object_type = "organization.Organization"
    moid        = data.intersight_organization_organization.organization.results[0].moid
  }
}


############################################################
# GET IP POOL MOID
############################################################
data "intersight_ippool_pool" "k8s_pool" {
  name = var.ip_pool
}


############################################################
# CREATE K8S PROFILE
############################################################
resource "intersight_kubernetes_cluster_profile" "profile" {

  name = var.cluster_name

  action = "Unassign"
	
  #wait_for_completion = false

  cluster_ip_pools {
    moid = data.intersight_ippool_pool.k8s_pool.results[0].moid
    object_type = "ippool.Pool"
  }

  management_config {
    load_balancer_count = var.loadbalancer_count
    
    ssh_user = var.ssh_user
    ssh_keys = var.ssh_keys
    
    encrypted_etcd = true
  }

  sys_config {
    moid = intersight_kubernetes_sys_config_policy.k8s_sysconfig.moid
    object_type = "kubernetes.SysConfigPolicy"
  }

  net_config {
    moid = intersight_kubernetes_network_policy.k8s_network.moid
    object_type = "kubernetes.NetworkPolicy"
  }
  
  dynamic "container_runtime_config" {
    for_each = intersight_kubernetes_container_runtime_policy.k8s_runtime
    content {
      moid = intersight_kubernetes_container_runtime_policy.k8s_runtime[0].moid
      object_type = "kubernetes.ContainerRuntimePolicy"
    }
  }

  organization {
    object_type = "organization.Organization"
    moid        = data.intersight_organization_organization.organization.results[0].moid
  }
}


############################################################
# CREATE MASTER NODE GROUP FOR CLUSTER
############################################################
resource "intersight_kubernetes_node_group_profile" "mastergroup" {
  name      = "${var.cluster_name}_mastergroup"
  node_type = "ControlPlane"
  
  desiredsize = var.master_count

  cluster_profile {
    moid = intersight_kubernetes_cluster_profile.profile.moid
    object_type = "kubernetes.ClusterProfile" 
  }

  kubernetes_version {
    moid = intersight_kubernetes_version_policy.version.moid
    object_type = "kubernetes.VersionPolicy"
  }
  
  ip_pools {
    moid = data.intersight_ippool_pool.k8s_pool.results[0].moid
    object_type = "ippool.Pool"
  }
}

resource "intersight_kubernetes_virtual_machine_infrastructure_provider" "mastergroup" {
  name = "${var.cluster_name}_mastergroup_infra"
  
  infra_config_policy {
    moid = intersight_kubernetes_virtual_machine_infra_config_policy.infra_policy.moid
    object_type = "kubernetes.VirtualMachineInfraConfigPolicy"
  }
  
  instance_type {
    moid = intersight_kubernetes_virtual_machine_instance_type.nodetype.moid
    object_type = "kubernetes.VirtualMachineInstanceType"
  }
  
  node_group {
    moid = intersight_kubernetes_node_group_profile.mastergroup.moid 
    object_type = "kubernetes.NodeGroupProfile"
  }
}


############################################################
# CREATE WORKER NODE GROUP FOR CLUSTER
############################################################
resource "intersight_kubernetes_node_group_profile" "workergroup" {
  name      = "${var.cluster_name}_workergroup"
  node_type = "Worker"
  
  desiredsize = var.worker_count

  cluster_profile {
    moid = intersight_kubernetes_cluster_profile.profile.moid
    object_type = "kubernetes.ClusterProfile" 
  }

  kubernetes_version {
    moid = intersight_kubernetes_version_policy.version.moid
    object_type = "kubernetes.VersionPolicy"
  }
  
  ip_pools {
    moid = data.intersight_ippool_pool.k8s_pool.results[0].moid
    object_type = "ippool.Pool"
  }
}

resource "intersight_kubernetes_virtual_machine_infrastructure_provider" "workergroup" {
  name = "${var.cluster_name}_workergroup_infra"
  
  infra_config_policy {
    moid = intersight_kubernetes_virtual_machine_infra_config_policy.infra_policy.moid
    object_type = "kubernetes.VirtualMachineInfraConfigPolicy"
  }
  
  instance_type {
    moid = intersight_kubernetes_virtual_machine_instance_type.nodetype.moid
    object_type = "kubernetes.VirtualMachineInstanceType"
  }
  
  node_group {
    moid = intersight_kubernetes_node_group_profile.workergroup.moid 
    object_type = "kubernetes.NodeGroupProfile"
  }
}


############################################################
# DEPLOY PROFILE
############################################################
#resource "intersight_kubernetes_cluster_profile" "profile_deploy" {
#  depends_on = [intersight_kubernetes_node_group_profile.mastergroup]
#  
#  action = "Deploy"
#  
#  name = var.cluster_name
#  
#  organization {
#    object_type = "organization.Organization"
#    moid        = data.intersight_organization_organization.organization.results[0].moid
#  }
#}


############################################################
# KUBECONFIG OUTPUT
############################################################
output "kube_config" {
  value = intersight_kubernetes_cluster_profile.profile.kube_config[0].kube_config
}
