output "manager_credentials" {
  sensitive = true
  value = confluent_api_key.app-manager-kafka-api-key
}

output "service_accounts_credentials" { 
  value = { for k, s in confluent_api_key.sa-kafka-api-key : k => { 
    id = s.id
    name = s.display_name
    description = s.description
    managed_resource = s.managed_resource
    owner= s.owner
    secret = s.secret
  }} 
}

output "manager_service_account" { 
  value = {    
    id = confluent_api_key.app-manager-kafka-api-key.id
    name = confluent_api_key.app-manager-kafka-api-key.display_name
    description = confluent_api_key.app-manager-kafka-api-key.description
    managed_resource = confluent_api_key.app-manager-kafka-api-key.managed_resource
    owner= confluent_api_key.app-manager-kafka-api-key.owner
    secret = confluent_api_key.app-manager-kafka-api-key.secret 
  }
}

output "sa_accounts" {
  value = local.sa_accounts
}

output "cli_group_maps" {
  value = local.sa_accounts_groups
}