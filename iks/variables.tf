variable "api_key_id" {
  default = "5a53d2043768393836b871c1/5b7c7d7e663471746d0ee3a4/5f62651e7564612d32771e7d"
}
variable "api_private_key" {
  default = "/mnt/c/Users/markpsmi/Desktop/Intersight/intersight-rest-api/key/SecretKey.txt"
}
variable "api_endpoint" {
  default = "https://www.intersight.com"
}
variable "org" {
  type        = string
  default     = "default"
  description = "Intersight organization which the cluster belongs to."
}

variable "cluster_name" {
  type        = string
  description = "The name of the Kubernetes cluster in Intersight. This property is used to name all policies and profiles."
}

variable "k8s_version" {
  type        = string
  default     = "1.19.5"
  description = "The Kubernetes version that the created cluster will be based on."
}

variable "dns_servers" {
  type        = list
  description = "A list of DNS servers that will be used for configuring the Kubernetes cluster."
}

variable "ntp_servers" {
  type        = list
  description = "A list of NTP servers that will be used for configuring the Kubernetes cluster."
}

variable "timezone" {
  type        = string
  description = "A timezone that will be used for configuring the Kubernetes cluster."
}

variable "pod_network_cidr" {
  type        = string
  default     = "172.16.0.0/17"
  description = "The CIDR used for the Kubernetes Pod network."
}

variable "service_cidr" {
  type        = string
  default     = "172.16.128.0/17"
  description = "The CIDR used for the Kubernetes Service network."
}

variable "proxy_enabled" {
  type    = bool
  default = false
  description = "Determines if the cluster will be configured with a proxy for outside connectivity, for example for pulling container images from the Internet."
}

variable "http_proxy_hostname" {
  type    = string
  default = ""
  description = "The Proxy hostname used for outside HTTP connections."
}

variable "http_proxy_protocol" {
  type    = string
  default = "http"
  description = "The Proxy protocol used for outside HTTP connections."
}

variable "http_proxy_port" {
  type    = string
  default = 80
  description = "The Proxy port used for outside HTTP connections."
}

variable "https_proxy_hostname" {
  type    = string
  default = ""
  description = "The Proxy hostname used for outside HTTPS connections."
}

variable "https_proxy_protocol" {
  type    = string
  default = "https"
  description = "The Proxy protocol used for outside HTTPS connections."
}

variable "https_proxy_port" {
  type    = string
  default = 443
  description = "The Proxy port used for outside HTTPS connections."
}

variable "cpu" {
  type        = string
  default     = "4"
  description = "The amount of CPU cores that will be assigned to each created Kubernetes Node/VM."
}

variable "memory" {
  type        = string
  default     = "4096"
  description = "The amount of memory that will be assigned to each created Kubernetes Node/VM."
}

variable "disk_size" {
  type        = string
  default     = "25"
  description = "The disk size of each created Kubernetes Node/VMs."
}

variable "vcenter_target" {
  type        = string
  description = "The target name of the vCenter target in Intersight. Keep in mind that this does not have to be the DNS name of vCenter, but rather the name in the Intersight Targets."
}

variable "vcenter_cluster" {
  type    = string
  description = "The name of the vCenter cluster in which the Kubernetes Nodes will be provisioned."
}

variable "vcenter_datastore" {
  type    = string
  description = "The name of the vCenter datastore which will be used for storing the data of the Kubernetes Nodes/VMs."
}

variable "vcenter_network" {
  type    = list
  description = "The name of the vCenter networks which the Kubernetes Nodes/VMs will be attached to."
}

variable "vcenter_passphrase" {
  type    = string
  description = "The admin password of the ESXi hosts in the cluster."
}

variable "ip_pool" {
  type        = string
  description = "The name of the Intersight IP pool that is used for reserving IP addresses for all cluster Nodes/VMs."
}

variable "master_count" {
  type    = number
  default = 3
  description = "The amount of Kubernetes Master Nodes/VMs to be provisioned. Can be 1 (No HA) or 3 (HA enabled)."
}

variable "worker_count" {
  type    = number
  default = 4
  description = "The amount of Kubernetes Worker Nodes/VMs to be provisioned. This has to be a value larger than 0."
}

variable "loadbalancer_count" {
  type    = number
  default = 1
  description = "The number of LoadBalancers that will be provisioned for the cluster. Each LoadBalancer consumes one IP address."
}

variable "ssh_user" {
  type        = string
  default     = "iksadmin"
  description = "The SSH user that will be created on the cluster. This user is used when instantiating SSH connections to the Nodes/VMs of the cluster."
}

variable "ssh_keys" {
  type        = list
  description = "The SSH key(s) that will be created on the cluster. This user is used when instantiating SSH connections to the Nodes/VMs of the cluster."
}
