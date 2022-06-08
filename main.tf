 
data "confluent_environment" "environment" {
  id = var.environment
} 

module "cluster" {
  source      = "./modules/cluster"
  environment = data.confluent_environment.environment.id
  cluster     = var.cluster
}

module "saccount_admins" { 
  source       = "./modules/saccount"
  environment  = data.confluent_environment.environment.id
  cluster      = module.cluster.ccloud_cluster.id
  serv_account = var.serv_account_admin
  rbac_enabled = module.cluster.rbac_enabled
  depends_on = [
    module.cluster.ccloud_cluster
  ]
}

module "saccount" {
  for_each     = { for sa in var.serv_accounts : sa.name => sa }
  source       = "./modules/saccount"
  environment  = data.confluent_environment.environment.id
  cluster      = module.cluster.ccloud_cluster.id
  serv_account = each.value
  rbac_enabled = module.cluster.rbac_enabled
  depends_on = [
    module.cluster.ccloud_cluster
  ]
}
 
module "topic" {
  for_each     = { for topic in var.topics : topic.name => topic }
  source       = "./modules/topic"
  environment  = data.confluent_environment.environment.id
  cluster      = module.cluster.ccloud_cluster.id
  topic        = each.value
  sa           = module.saccount_admins.service_accounts_credentials
  rbac_enabled = module.cluster.rbac_enabled
  depends_on = [
    module.saccount_admins.service_accounts_credentials,
    module.saccount.service_accounts_credentials,
    module.cluster.ccloud_cluster
  ]
}
 
