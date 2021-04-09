resource "intersight_vmedia_policy" "vmedia1" {
  name          = "MSCI"
  description   = "test policy"
  enabled       = true
  encryption    = true
  low_power_usb = true

 
  organization {
    object_type = "organization.Organization"
    moid = data.intersight_organization_organization.organization_moid.moid
  }
}
