resource "intersight_vmedia_policy" "vmedia1" {
  name          = "Terraform"
  description   = "Provisioned with Terraform"
  mappings {
    device_type    = "cdd"
    mount_protocol = "http"
    volume_name   = "ESXi-6.5a-LD"
    file_location = "https://172.16.58.2/path/to/iso/VMware_ESXi_6.7.0_14320388_Custom_Cisco_6.7.3.1.iso"
    mount_options = "http"
    authentication_protocol = "none"
  }
  organization {
    object_type = "organization.Organization"
    moid        = data.intersight_organization_organization.organization_moid.id
  }
   profiles {
    moid        = intersight_server_profile.server1.id
    object_type = "server.Profile"
  }
}

