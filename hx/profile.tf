resource "intersight_hyperflex_cluster_profile" "hyperflex_cluster_profile1" {
  storage_data_vlan {
    name    = "hx-storage-data"
    vlan_id = var.hxdp_vlan
  }
  
  software_version {
    moid        = intersight_hyperflex_software_version_policy.hyperflex_software_version_policy1.moid
    object_type = "hyperflex.SoftwareVersionPolicy"
  }
  local_credential {
    moid        = intersight_hyperflex_local_credential_policy.hyperflex_local_credential_policy1.moid
    object_type = "hyperflex.LocalCredentialPolicy"
  }
  sys_config {
    moid        = intersight_hyperflex_sys_config_policy.hyperflex_sys_config_policy1.moid
    object_type = "hyperflex.SysConfigPolicy"
  }
  node_config {
    moid        = intersight_hyperflex_node_config_policy.hyperflex_node_config_policy1.moid
    object_type = "hyperflex.NodeConfigPolicy"
  }

  cluster_network  {
    moid        = intersight_hyperflex_cluster_network_policy.hyperflex_cluster_network_policy1.moid
    object_type = "hyperflex.ClusterNetworkPolicy"
  }
  cluster_storage  {
    moid        = intersight_hyperflex_cluster_storage_policy.hyperflex_cluster_storage_policy1.moid
    object_type = "hyperflex.ClusterStoragePolicy"
  }
  vcenter_config  {
    moid        = intersight_hyperflex_vcenter_config_policy.hyperflex_vcenter_config_policy1.moid
    object_type = "hyperflex.VcenterConfigPolicy"
  }
  
  tags {
    key   = "deployment"
    value = "terraform"
  }
  organization {
    object_type = "organization.Organization"
    moid        = data.intersight_organization_organization.org.results[0].moid
  }
  name = var.hxdp_cluster_name
  mgmt_ip_address    = var.hxdp_cluster
  mac_address_prefix = "00:25:B5:D5"
  mgmt_platform = "FI"
  replication   = 3
  description   = "This HX Profile is created by Terraform"
  hypervisor_type = "ESXi"
  storage_type    = "HyperFlexDp"
}

