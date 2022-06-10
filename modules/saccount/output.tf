
output "service_accounts_credentials" { 
  value = confluent_api_key.saccount_kafka_api_key 
}
 
output "service_account_group" {
  value = confluent_role_binding.saccount_group
}

output "service_account_role" {
  value = confluent_role_binding.saccount_role
}