cluster_name = "Expedia-iks"
cluster_action   = "Deploy"

vc_target_name ="vcsa.rich.ciscolabs.com"
dns_servers = ["10.101.128.15"]
domain_name = "rich.ciscolabs.com"
ntp_servers = ["ntp.esl.cisco.com"]
 
timezone = "America/New_York"
vc_cluster = "Core"
  
vc_datastore = "pure-ds01"
vc_portgroup = ["labServers-3001"]
ip_starting_address = "10.101.128.171"
ip_pool_size = "20"
ip_netmask = "255.255.255.0"
ip_gateway = "10.101.128.1"
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
