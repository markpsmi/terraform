# VPC

output "webserver_ip" {
  value = vsphere_virtual_machine.webserver[*].default_ip_address
}
output "db_ip" {
  value = vsphere_virtual_machine.dbserver[*].default_ip_address
}

