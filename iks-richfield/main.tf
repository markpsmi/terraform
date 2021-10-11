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
    ip_starting_address = "10.101.128.171"
    ip_pool_size        = "20"
    ip_netmask          = "255.255.255.0"
    ip_gateway          = "10.101.128.1"
    dns_servers         = ["10.101.128.15"]
  }

  sysconfig = {
    use_existing = false
    name         = "Marks"
    domain_name  = "rich.ciscolabs.com"
    timezone     = "America/New_York"
    ntp_servers  = ["ntp.esl.cisco.com"]
    dns_servers  = ["10.101.128.15"]
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
    name         = "marks_1.19.5"
    version      = "1.19.5"
  }

  # tr_policy_name = "marks"
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
    vc_target_name   = "vcsa.rich.ciscolabs.com"
    vc_portgroups    = ["labServers-3001"]
    vc_datastore     = "pure-ds01"
    vc_cluster       = "Core"
    vc_resource_pool = ""
    vc_password      = var.vc_password
  }

  addons_list = [{
    addon_policy_name = "marks_dashboard"
    addon             = "kubernetes-dashboard"
    description       = "K8s Dashboard Policy"
    upgrade_strategy  = "AlwaysReinstall"
    install_strategy  = "InstallOnly"
    },
    {
      addon_policy_name = "marks_monitor"
      addon             = "ccp-monitor"
      description       = "Grafana Policy"
      upgrade_strategy  = "AlwaysReinstall"
      install_strategy  = "InstallOnly"
    }
  ]
  instance_type = {
    use_existing = false
    name         = "marks_small"
    cpu          = 4
    memory       = 16386
    disk_size    = 40
  }
  # Cluster information
  cluster = {
    name                = "marks-iks-cluster"
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
 
