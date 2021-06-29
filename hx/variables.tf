variable "api_key" {
  type = string
  description = "API Key Id from Intersight"
}
variable "secretkey" {
  type = string
  description = "The path to your secretkey for Intersight OR the your secret key as a string"
}
variable "organization" {
  type = string
  description = "Organization Name"
  default = "default"
}
variable "password" {
    type = string
    description = "Default Password"
}
variable "env" {
    type = string
    description = "Environment"
}
variable "dns_domain_suffix" {
    type = string
    description = "DNS Domain Suffix"
}
variable "subnet_str" {
    type = string
    description = "Subnet String"
}
variable "mgmt_vlan" {
  type        = string
  description = "The MGMT VLAN for HyperFlex"
}
variable "vmotion_vlan" {
  type        = string
  description = "The vMotion VLAN for HyperFlex"
}
variable "hxdp_vlan" {
  type        = string
  description = "The HXDP VLAN for HyperFlex"
}
variable "vm_vlans" {
  type        = list(number)
  description = "The VLANs that will be created"
}
variable "vcenter_url" {
  type = string
  description = "FQDN of the vCenter server"
}
variable "vcenter_username" {
  type = string
  description = "Username of the vCenter server"
}
variable "vcenter_password" {
  type = string
  description = "Password of the vCenter server"
}
variable "dns_server" {
  type = string
  description = "Password of the vCenter server"
}
variable "ntp_server" {
  type = string
  description = "Password of the vCenter server"
}
variable "kvm_start" {
  type = string
  description = "KVM IP Block start IP"
}
variable "kvm_end" {
  type = string
  description = "KVM IP Block end IP"
}
variable "kvm_netmask" {
  type = string
  description = "KVM IP Block subnetmask"
}
variable "kvm_gateway" {
  type = string
  description = "KVM IP Block default gateway"
}
variable "timezone" {
  type = string
  description = "Time Zone"
}
variable "esxi_start" {
  type = string
  description = "ESXi MGMT IP Block start IP"
}
variable "esxi_end" {
  type = string
  description = "ESXi MGMT IP Block end IP"
}
variable "esxi_netmask" {
  type = string
  description = "ESXi MGMT IP Block subnetmask"
}
variable "esxi_gateway" {
  type = string
  description = "ESXi MGMT IP Block default gateway"
}
variable "hxdp_start" {
  type = string
  description = "HXDP MGMT IP Block start IP"
}
variable "hxdp_end" {
  type = string
  description = "HXDP MGMT IP Block end IP"
}
variable "hxdp_netmask" {
  type = string
  description = "HXDP MGMT IP Block subnetmask"
}
variable "hxdp_gateway" {
  type = string
  description = "HXDP MGMT IP Block default gateway"
}
variable "hxdp_cluster" {
  type = string
  description = "HXDP Cluster IP"
}
variable "hxdp_cluster_name" {
  type = string
  description = "HXDP Cluster Name"
}
