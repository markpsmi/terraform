terraform {

  backend "remote" {
    organization = "Cisco-Richfield-Lab"

    workspaces {
      name = "imm-tfcb"
    }
  }

    required_providers {
        intersight = {
            source = "CiscoDevNet/intersight"
            version = ">=1.0.20"
        }
    }
}

provider "intersight" {
    apikey = var.api_key
    secretkey = var.secretkey
    endpoint = var.endpoint
}

data "intersight_organization_organization" "default" {
    name = "default"
}
# print default org moid
output "org_default_moid" {
    value = data.intersight_organization_organization.default.moid
}

module "intersight_policy_bundle" {
  source = "github.com/pl247/tf-intersight-policy-bundle"

  # external sources
  organization    = data.intersight_organization_organization.default.id

  # every policy created will have this prefix in its name
  policy_prefix = "bdc"
  description   = "Built by Terraform"

  # Fabric Interconnect 6454 config specifics
  server_ports_6454 = [17, 18, 19, 20, 21, 22]
  port_channel_6454 = [49, 50]
  uplink_vlans_6454 = {
    "vlan-998" : 998,
    "vlan-999" : 999
  }

  fc_port_count_6454 = 4

  imc_access_vlan    = 999
  imc_admin_password = "Cisco123"

  ntp_servers = ["ca.pool.ntp.org"]

  dns_preferred = "172.22.16.254"
  dns_alternate = "172.22.16.253"

  ntp_timezone = "America/Winnipeg"

# starting values for wwnn, wwpn-a/b and mac pools (size 255)
  wwnn-block   = "20:00:00:CA:FE:00:00:01"
  wwpn-a-block = "20:00:00:CA:FE:0A:00:01"
  wwpn-b-block = "20:00:00:CA:FE:0B:00:01"

  mac-block    = "00:CA:FE:00:00:01"

    tags = [
    { "key" : "Environment", "value" : "BDC-Prod" },
    { "key" : "Orchestrator", "value" : "Terraform" }
  ]
}
