cluster_name = "My-iks-cluster"
cluster_action   = "Deploy"
load_balancers = "5"
vc_target_name ="172.16.50.50"
dns_servers = ["208.67.220.220"]
domain_name = "glasshouse.com"
ntp_servers = ["171.68.10.80"]
 
timezone = "America/Los_Angeles"
vc_cluster = "MarkpsmiCL"
  
vc_datastore = "UCSDMarksmiBIGDS292"
vc_portgroup = ["VM Network"]
ip_starting_address = "172.16.59.52"
ip_pool_size = "20"
ip_netmask = "255.255.240.0"
ip_gateway = "172.16.50.254"
worker_size = "small"
ssh_user = "iksadmin"
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
