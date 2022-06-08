
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
  admin_sa     = module.saccount_admins.service_accounts_credentials
  rbac_enabled = module.cluster.rbac_enabled
  depends_on = [
    module.saccount_admins, 
    module.saccount.service_accounts_credentials, 
    module.cluster.ccloud_cluster
  ]
}

module "connector" {
  count           = var.connector_deploy ? 1 : 0
  source          = "./modules/connector"
  environment     = data.confluent_environment.environment.id
  cluster         = module.cluster.ccloud_cluster.id
  topic           = var.connector.topic
  service_account = var.connector.service_account
  config          = var.connector.config
  admin_sa        = module.saccount_admins.service_accounts_credentials 
  depends_on = [
    module.topic.created_topic,
    module.saccount_admins.service_accounts_credentials,
    module.saccount_admins.service_account_group,
    module.saccount.service_accounts_credentials,
    module.saccount.service_account_group,
    module.cluster.ccloud_cluster
  ]
}

