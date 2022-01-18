

resource "vsphere_virtual_machine" "dbserver" {
  count            = 1
  name             = "${var.db_server_prefix}-${random_string.folder_name_prefix.id}-${count.index + 1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  
  num_cpus = var.db_server_cpu
  memory  = var.db_server_memory
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = "${var.db_server_prefix}-${random_string.folder_name_prefix.id}-${count.index + 1}"
        domain    = var.vm_domain
      }
      network_interface {
      ipv4_address = "10.21.1.101"
      ipv4_netmask = 24
      }
      ipv4_gateway = "10.21.1.1"
      dns_server_list = ["10.112.10.11", "10.112.10.12"]
    }
  }
}

resource "null_resource" "db_init" {
  count = 1
  connection {
    type = "ssh"
    host = vsphere_virtual_machine.dbserver[0].default_ip_address
    user = "root"
    password = var.root_password
    port = "22"
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname --static dbserver-${count.index}",
      "wget -O /tmp/oc_db.yaml https://ccs-demo.s3.amazonaws.com/opencart_db.yaml",
      "sudo ansible-playbook -i localhost /tmp/oc_db.yaml"
    ]
  }
}


#output "vm_deploy" {
#  value = [vsphere_virtual_machine.vm_deploy.*.name, vsphere_virtual_machine.vm_deploy.*.default_ip_address]
#}
