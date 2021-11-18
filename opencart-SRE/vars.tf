// The vsphere ip address
variable "vsphere_server" {
  type = string
}

// The vsphere user
variable "vsphere_user" {
  type = string
  default = ""
}

// The vsphere password
variable "vsphere_password" {
  type = string
}

// The datacenter the resources will be created in.
variable "datacenter" {
  type = string
}
// The cluster the resources will be created in.
variable "cluster_name" {
  type = string
}

// The resource pool the virtual machines will be placed in.
variable "resource_pool" {
  type = string
}

// The name of the datastore to use.
variable "datastore_name" {
  type = string
}

// The name of the network to use.
variable "network_name" {
  type = string
}

// The name of the template to use when cloning.
variable "template_name" {
  type = string
}


variable "vm_prefix" {
  type = string
}

variable "vm_folder" {
  default = "test"
  type = string
}


variable "web_server_count" {
  default     = 2
  description = "Number of web servers"
}

variable "web_server_prefix" {
  default ="webserver"
}

variable "db_server_prefix" {
  default ="db"
}

// The name prefix of the virtual machines to create.
variable "vm_domain" {
  type = string
}
variable "root_password" {
  type = string
}

variable "db_server_cpu" {
  type = string
}
variable "db_server_memory" {
  type = string
}
variable "web_server_cpu" {
  type = string
}
variable "web_server_memory" {
  type = string
}
