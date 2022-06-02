output "environment" {
  value = data.confluent_environment.environment.id
}

output "cluster" {
  value = {
    id            = module.cluster.ccloud_cluster.id
    region        = module.cluster.ccloud_cluster.region
    http_endpoint = module.cluster.ccloud_cluster.http_endpoint
    rbac_crn      = module.cluster.ccloud_cluster.rbac_crn
  }
}

output "saccount" {
  sensitive = true
  value     = module.saccount.manager_service_account
}

output "sas" {
  sensitive = true
  value = {
    for k, s in module.saccount.service_accounts_credentials : k => {
      name   = k
      id     = s.id
      secret = s.secret
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
