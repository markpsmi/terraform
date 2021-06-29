data "intersight_organization_organization" "org" {
    name = var.organization
}

resource "intersight_hyperflex_vcenter_config_policy" "hyperflex_vcenter_config_policy1" {
  hostname    = var.vcenter_url
  username    = var.vcenter_username
  password    = var.vcenter_password
  data_center = var.env
  sso_url     = ""
  organization {
    object_type = "organization.Organization"
    moid        = data.intersight_organization_organization.org.results[0].moid
  }
  name = "${var.env}_HyperFlex_vCenter_Policy"
  description = "Created by Terraform"
}

resource "intersight_hyperflex_local_credential_policy" "hyperflex_local_credential_policy1" {
  hxdp_root_pwd               = var.password
  hypervisor_admin            = "root"
  hypervisor_admin_pwd        = var.password
  factory_hypervisor_password = false
  organization {
    object_type = "organization.Organization"
    moid        = data.intersight_organization_organization.org.results[0].moid
  }
  name = "${var.env}_Hyperflex_local_credential_policy"
  description = "Created by Terraform"
}

resource "intersight_hyperflex_sys_config_policy" "hyperflex_sys_config_policy1" {
  dns_servers     = [var.dns_server]
  ntp_servers     = [var.ntp_server]
  timezone        = var.timezone
  dns_domain_name = var.dns_domain_suffix
  organization {
    object_type = "organization.Organization"
    moid        = data.intersight_organization_organization.org.results[0].moid
  }
  name = "${var.env}_HyperFlex_System_Config_Policy"
  description = "Created by Terraform"
}

resource "intersight_hyperflex_cluster_storage_policy" "hyperflex_cluster_storage_policy1" {
  disk_partition_cleanup = true
  vdi_optimization       = true
  organization {
    object_type = "organization.Organization"
    moid        = data.intersight_organization_organization.org.results[0].moid
  }
  name = "${var.env}_HyperFlex_Storage_Cluster_Policy"
  description = "Created by Terraform"
}

resource "intersight_hyperflex_cluster_network_policy" "hyperflex_cluster_network_policy1" {
  mgmt_vlan {
    name    = "hx-inband-mgmt"
    vlan_id = var.mgmt_vlan
}
  jumbo_frame  = true
  uplink_speed = "default"
  vm_migration_vlan {
    name = "HX-Migration"
    vlan_id = var.vmotion_vlan
  }

  vm_network_vlans = [
    for vlan in var.vm_vlans :
    {
        name = "HX-${var.env}-VM-VLAN-${tostring(vlan)}"
        vlan_id = vlan
        class_id = "hyperflex.NamedVlan"
        object_type = "hyperflex.NamedVlan"
        additional_properties = ""
    }
  ]

  mac_prefix_range {
    end_addr   = "00:25:B5:D5"
    start_addr = "00:25:B5:D5"
  }
  kvm_ip_range {
    start_addr = var.kvm_start
    end_addr = var.kvm_end
    gateway = var.kvm_gateway
    netmask = var.kvm_netmask
  }
  organization {
    object_type = "organization.Organization"
    moid        = data.intersight_organization_organization.org.results[0].moid
  }
  name = "${var.env}_HyperFlex_Cluster_Network_Policy"
  description = "Created by Terraform"
}

resource "intersight_hyperflex_node_config_policy" "hyperflex_node_config_policy1" {
  mgmt_ip_range {
    start_addr = var.esxi_start
    end_addr = var.esxi_end
    gateway = var.esxi_gateway
    netmask = var.esxi_netmask
  }
  hxdp_ip_range {
    start_addr = var.hxdp_start
    end_addr = var.hxdp_end
    gateway = var.hxdp_gateway
    netmask = var.hxdp_netmask
  }
  node_name_prefix = "HX-${var.env}"
  organization {
    object_type = "organization.Organization"
    moid        = data.intersight_organization_organization.org.results[0].moid
  }
  name = "${var.env}_HX_Node_Configuration_Policy"
  description = "Created by Terraform"
}

resource "intersight_hyperflex_ucsm_config_policy" "hyperflex_ucsm_config_policy1" {
  name        = "${var.env}_HyperFlex_UCSM_Configuration_Policy"
  description = "Created by Terraform"
  kvm_ip_range {
    start_addr = var.kvm_start
    end_addr = var.kvm_end
    gateway = var.kvm_gateway
    netmask = var.kvm_netmask
  }
  server_firmware_version = "4.1(2b)"
  organization {
    object_type = "organization.Organization"
    moid        = data.intersight_organization_organization.org.results[0].moid
  }
}

resource "intersight_hyperflex_software_version_policy" "hyperflex_software_version_policy1" {
  hxdp_version = "4.5(1a)"
  server_firmware_version = "4.1(2b)"
  organization {
    object_type = "organization.Organization"
    moid        = data.intersight_organization_organization.org.results[0].moid
  }
  name = "${var.env}_Hyperflex_software_version"
}
