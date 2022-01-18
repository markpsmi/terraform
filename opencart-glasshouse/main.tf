terraform {
  required_providers {

    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.0.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.0.0"
    }

    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }

  }

#  required_version = "~> 0.14"
}

# Configure the VMware vSphere Provider
provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}
data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.dc.id
}
resource "random_string" "folder_name_prefix" {
  length    = 10
  min_lower = 10
  special   = false
  lower     = true
}
resource "vsphere_folder" "vm_folder" {
  path          =  "${var.vm_folder}-${random_string.folder_name_prefix.id}"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}
