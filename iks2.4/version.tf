terraform {
  required_version = ">=0.14.5"

  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      version = "=1.0.18"
    }
    aci = {
      source = "ciscodevnet/aci"
      version = "0.4.1"
    }
  }
}
