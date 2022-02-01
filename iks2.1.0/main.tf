provider "intersight" {
  apikey    = var.apikey
  secretkey = var.secretkey
  endpoint  = var.endpoint
}

module "terraform-intersight-iks" {

  source  = "terraform-cisco-modules/iks/intersight//"
  version = "2.2"

# Kubernetes Cluster Profile  Adjust the values as needed.
  cluster = {
    name                = "Marks_iks_cluster2"
    action              = "Unassign"
    wait_for_completion = false
    worker_nodes        = 1
    load_balancers      = 6
    worker_max          = 4
    control_nodes       = 1
    ssh_user            = var.ssh_user
    ssh_public_key      = var.ssh_key
  }


# IP Pool Information (To create new change "use_existing" to 'false' uncomment variables and modify them to meet your needs.)
  ip_pool = {
    use_existing        = false
    name                = "marks_ip_pool"
    ip_starting_address = "172.16.59.100"
    ip_pool_size        = "30"
    ip_netmask          = "255.255.240.0"
    ip_gateway          = "172.16.50.254"
    dns_servers         = ["172.16.50.35"]
  }

# Sysconfig Policy (UI Reference NODE OS Configuration) (To create new change "use_existing" to 'false' uncomment variables and modify them to meet your needs.)
  sysconfig = {
    use_existing = false
    name         = "marks"
    domain_name  = "glasshouse.com"
    timezone     = "America/Los_Angeles"
    ntp_servers  = ["172.16.50.35"]
    dns_servers  = ["172.16.50.35"]
  }

# Kubernetes Network CIDR (To create new change "use_existing" to 'false' uncomment variables and modify them to meet your needs.)
  k8s_network = {
    use_existing = false
    name         = "default1"

    ######### Below are the default settings.  Change if needed. #########
    pod_cidr     = "100.100.0.0/16"
    service_cidr = "100.101.0.0/16"
    cni          = "Calico"
  }
# Version policy (To create new change "useExisting" to 'false' uncomment variables and modify them to meet your needs.)
  versionPolicy = {
    useExisting = false
    policyName     = "1.20.14-iks.0"
    iksVersionName = "1.20.14-iks.0"
  }
    
# Trusted Registry Policy (To create new change "use_existing" to 'false' and set "create_new' to 'true' uncomment variables and modify them to meet your needs.)
# Set both variables to 'false' if this policy is not needed.
  tr_policy = {
    use_existing = false
    create_new   = false
    name         = "trusted-registry"
  }
# Runtime Policy (To create new change "use_existing" to 'false' and set "create_new' to 'true' uncomment variables and modify them to meet your needs.)
# Set both variables to 'false' if this policy is not needed.
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

# Infrastructure Configuration Policy (To create new change "use_existing" to 'false' and uncomment variables and modify them to meet your needs.)
  infraConfigPolicy = {
    use_existing = false
    platformType = "esxi"
    targetName   = "172.16.50.50"
    policyName   = "marksvcenter"
    description  = "Test Policy"
    interfaces   = ["VM Network"]
    vcTargetName   = "172.16.50.50"
    vcClusterName      = "MarkpsmiCL"
    vcDatastoreName     = "UCSDMarksmiBIGDS292"
    vcResourcePoolName = ""
    vcPassword      = var.vcPassword
  }

# Addon Profile and Policies (To create new change "createNew" to 'true' and uncomment variables and modify them to meet your needs.)
# This is an Optional item.  Comment or remove to not use.  Multiple addons can be configured.
  addons       = [
   # {
   # createNew = true
   # addonPolicyName = "smm-tf"
   # addonName            = "smm"
   # description       = "SMM Policy"
   # upgradeStrategy  = "AlwaysReinstall"
   # installStrategy  = "InstallOnly"
   # releaseVersion = "1.7.4-cisco4-helm3"
   # overrides = yamlencode({"demoApplication":{"enabled":true}})
   # },
    {
    createNew = false
    addonPolicyName = "marks-dashboard"
    # addonName       = "kubernetes-dashboard"
    # description       = "K8s Dashboard Policy"
    # upgradeStrategy  = "AlwaysReinstall"
    # installStrategy  = "InstallOnly"
    # releaseVersion = "3.0.2-cisco6-helm3"
    # overrides = yamlencode({"demoApplication":{"enabled":true}})  
    }  
    # {
    # createNew = true
    # addonName            = "ccp-monitor"
    # description       = "monitor Policy"
    # # upgradeStrategy  = "AlwaysReinstall"
    # # installStrategy  = "InstallOnly"
    # releaseVersion = "0.2.61-helm3"
    # # overrides = yamlencode({"demoApplication":{"enabled":true}})
    # }
  ]

# Worker Node Instance Type (To create new change "use_existing" to 'false' and uncomment variables and modify them to meet your needs.)
  instance_type = {
    use_existing = false
    name         = "marks-small"
    # cpu          = 4
    # memory       = 16386
    # disk_size    = 40
  }

# Organization and Tag Information
  organization = var.organization
  tags         = var.tags
}
