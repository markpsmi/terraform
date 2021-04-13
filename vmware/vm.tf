data "vsphere_datacenter" "dc" {
  name = "MarkpsmiDC"
}

data "vsphere_datastore" "datastore" {
  name          = "UCSDMarksmiBIGDS292"
  datacenter_id = "data.vsphere_datacenter.dc.id"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "MarkpsmiCL"
  datacenter_id = "data.vsphere_datacenter.dc.id"
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = "data.vsphere_datacenter.dc.id"
}

data "vsphere_virtual_machine" "template" {
  name          = "CentOS7-Temp"
  datacenter_id = "data.vsphere_datacenter.dc.id"
}

resource "vsphere_virtual_machine" "vm" {
  name             = "terraform-test"
  resource_pool_id = "data.vsphere_compute_cluster.cluster.resource_pool_id"
  datastore_id     = "data.vsphere_datastore.datastore.id"

  num_cpus = 2
  memory   = 1024
  guest_id = "data.vsphere_virtual_machine.template.guest_id"

  scsi_type = "lsilogic"

  network_interface {
    network_id   = "data.vsphere_network.network.id"
    adapter_type = "vmxnet3"
  }

  clone {
    template_uuid = "data.vsphere_virtual_machine.template.id"

    customize {
      linux_options {
        host_name = "terraform-test"
        domain    = "test.internal"
      }

      network_interface {
        ipv4_address = "172.16.58.240"
        ipv4_netmask = 20
      }

      ipv4_gateway = "172.16.50.254"
    }
  }
}
