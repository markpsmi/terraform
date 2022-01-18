


resource "vsphere_virtual_machine" "webserver" {
  count            = var.web_server_count
  name             = "${var.web_server_prefix}-${random_string.folder_name_prefix.id}-${count.index + 1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.web_server_cpu
  memory  = var.web_server_memory
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
        host_name = "${var.web_server_prefix}-${random_string.folder_name_prefix.id}-${count.index + 1}"
        domain    = var.vm_domain
      }
      network_interface {
      dns_server_list = ["10.112.10.11", "10.112.10.12"]
      ipv4_address = "10.21.1.${102 + count.index}"
      ipv4_netmask = 24
      }
      ipv4_gateway = "10.21.1.1"
      dns_server_list = ["10.112.10.11", "10.112.10.12"]
    }
  }


}

resource "null_resource" "webserver_init" {
  count = var.web_server_count
  depends_on = [vsphere_virtual_machine.webserver]
  connection {
    type = "ssh"
    host = vsphere_virtual_machine.webserver[count.index].default_ip_address
    user = "root"
    password = var.root_password
    port = "22"
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname --static webserver-${count.index}",
      "wget -O /tmp/oc.yaml https://ccs-demo.s3.amazonaws.com/opencart.yaml",
      "sudo ansible-playbook -i localhost /tmp/oc.yaml",
      "if [ $(hostname) == 'webserver-0' ]; then sudo cd /var/www/html/opencart/install; sudo php /var/www/html/opencart/install/cli_install.php install --db_hostname ${vsphere_virtual_machine.dbserver[0].default_ip_address} --db_username ocuser --db_password cisco --db_database opencart --db_driver mysqli --db_port 3306 --username admin --password admin --email youremail@example.com --http_server http://${vsphere_virtual_machine.webserver[0].default_ip_address}/opencart/; fi",
      "sudo wget -O /tmp/config.php.sample https://ccs-demo.s3.amazonaws.com/config.php.sample",
      "sudo sed -i 's/<OC_SERVER>/${vsphere_virtual_machine.webserver[count.index].default_ip_address}/g' /tmp/config.php.sample",
      "sudo sed -i 's/<OC_DB_SERVER>/${vsphere_virtual_machine.dbserver[0].default_ip_address}/g' /tmp/config.php.sample",
      "sudo sed -i 's/<OC_DB_USERNAME>/ocuser/g' /tmp/config.php.sample",
      "sudo sed -i 's/<OC_DB_PASSWORD>/cisco/g' /tmp/config.php.sample",
      "sudo sed -i 's/<OC_DB_DATABASE>/opencart/g' /tmp/config.php.sample",
      "if [ $(hostname) != 'webserver-0' ]; then sudo cp /tmp/config.php.sample /var/www/html/opencart/config.php; fi",
      "sudo rm /tmp/config.php.sample"
    ]
  }
}

