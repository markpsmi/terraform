provider "intersight" {
  apikey    = var.apikey
  secretkey = var.secretkey
  endpoint  = var.endpoint
}

module "terraform-intersight-iks" {

  source = "terraform-cisco-modules/iks/intersight//"


  ip_pool = {
    use_existing        = false
    name                = "marks_ippool"
    ip_starting_address = "172.16.59.2"
    ip_pool_size        = "20"
    ip_netmask          = "255.255.240.0"
    ip_gateway          = "172.16.50.254"
    dns_servers         = ["208.67.220.220"]
  }

  sysconfig = {
    use_existing = false
    name         = "Mark"
    domain_name  = "glasshouse.com"
    timezone     = "America/Los_Angeles"
    ntp_servers  = ["171.68.10.80"]
    dns_servers  = ["208.67.220.220"]
  }

  k8s_network = {
    use_existing = false
    name         = "default"

    ######### Below are the default settings.  Change if needed. #########
    pod_cidr     = "100.65.0.0/16"
    service_cidr = "100.64.0.0/24"
    cni          = "Calico"
  }
  # Version policy
  version_policy = {
    use_existing = false
    name         = "1.19.5"
    version      = "1.19.5"
  }

  # tr_policy_name = "test"
  tr_policy = {
    use_existing = false
    create_new   = true
    name         = "triggermesh-trusted-registry"
  }
  runtime_policy = {
    use_existing = false
    create_new   = false
    # name                 = "runtime"
    # http_proxy_hostname  = "t"
    # http_proxy_port      = 80
    # http_proxy_protocol  = "http"
    # http_proxy_username  = null
    # http_proxy_password  = null
    # https_proxy_hostname = "t"
    # https_proxy_port     = 8080
    # https_proxy_protocol = "https"
    # https_proxy_username = null
    # https_proxy_password = null
  }

  # Infra Config Policy Information
  infra_config_policy = {
    use_existing     = false
    name             = "marksvcenter"
    vc_target_name   = "172.16.50.50"
    vc_portgroups    = ["VM Network"]
    vc_datastore     = "UCSDMarksmiBIGDS292"
    vc_cluster       = "MarkpsmiCL"
    vc_resource_pool = ""
    vc_password      = var.vc_password
  }

  addons_list = [{
    addon_policy_name = "dashboard"
    addon             = "kubernetes-dashboard"
    description       = "K8s Dashboard Policy"
    upgrade_strategy  = "AlwaysReinstall"
    install_strategy  = "InstallOnly"
    },
    {
      addon_policy_name = "monitor"
      addon             = "ccp-monitor"
      description       = "Grafana Policy"
      upgrade_strategy  = "AlwaysReinstall"
      install_strategy  = "InstallOnly"
    }
  ]
  instance_type = {
    use_existing = false
    name         = "small"
    cpu          = 4
    memory       = 16386
    disk_size    = 40
  }
  # Cluster information
  cluster = {
    name                = "knowledge_thurdays"
    action              = "Deploy"
    wait_for_completion = false
    worker_nodes        = 3
    load_balancers      = 5
    worker_max          = 20
    control_nodes       = 1
    ssh_user            = "iksadmin"
    ssh_public_key      = var.ssh_key
  }
  # Organization and Tag
  organization = var.organization
  tags         = var.tags
}
