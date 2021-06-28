resource "intersight_server_profile" "server1" {
  name = "Training"
  action = "No-op"
  tags {
    key = "server"
    value = "demo"
  }
  organization {
    object_type = "organization.Organization"
    moid = data.intersight_organization_organization.organization_moid.moid
  }
}
