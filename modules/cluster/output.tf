output "ccloud_cluster" {
  value = confluent_kafka_cluster.cluster
}

output "service_account_admin" {
  sensitive = true
  value     = module.saccount_admins.service_accounts_credentials
}

output "rbac_enabled" {
  value = local.rbac_enabled
}

output "service_accounts" {
  sensitive = true
  value = {
    for k, t in module.saccount : k => {
      id     = t.service_accounts_credentials.id
      name   = t.service_accounts_credentials.display_name
      secret = t.service_accounts_credentials.secret
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

output "acls" {
  value = {
    for k, t in module.acl : k => {
      acl = t.acl
    }
  }
}

output "source_connector" {
  value = {
    for k, t in module.connector : k => {
      connector = t.connector.id
    }
  }
}
