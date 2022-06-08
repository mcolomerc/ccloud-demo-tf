output "environment" {
  value = data.confluent_environment.environment.id
}

output "cluster" {
  value = {
    id            = module.cluster.ccloud_cluster.id
    region        = module.cluster.ccloud_cluster.region
    http_endpoint = module.cluster.ccloud_cluster.http_endpoint
    rbac_crn      = module.cluster.ccloud_cluster.rbac_crn
    kind          = module.cluster.ccloud_cluster.kind
  }
}
 

output "service_account_admin" { 
  sensitive = true
  value = module.saccount_admins.service_accounts_credentials 
}

output "service_account_admin_roles" {  
  value = module.saccount_admins.service_account_role[0]
}

output "service_accounts" { 
  sensitive = true
  value = {
    for k, t in module.saccount : k => {
      id         = t.service_accounts_credentials.id
      name       = t.service_accounts_credentials.display_name
      secret     = t.service_accounts_credentials.secret
    }
  }
}

 
output "topics" {
  value = {
    for k, t in module.topic : k => {
      id         = t.created_topic.id
      name       = t.created_topic.topic_name
      partitions = t.created_topic.partitions_count
      config     = t.created_topic.config
    }
  }
}
 