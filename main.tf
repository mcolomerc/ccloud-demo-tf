/* resource "confluent_environment" "environment" {
  display_name = var.environment
} */

data "confluent_environment" "environment" {
  id = var.environment
}


module "cluster" {
  source      = "./modules/cluster"
  environment = data.confluent_environment.environment.id
  cluster     = var.cluster
}

module "saccount" {
  source                  = "./modules/saccount"
  environment             = data.confluent_environment.environment.id
  cluster                 = module.cluster.ccloud_cluster.id
  service_account_manager = var.service_account_manager
  service_accounts        = var.service_accounts
  depends_on = [
    module.cluster.ccloud_cluster
  ]
}

module "topic" {
  for_each    = { for topic in var.topics : topic.name => topic }
  source      = "./modules/topic"
  environment = data.confluent_environment.environment.id
  cluster     = module.cluster.ccloud_cluster.id
  topic       = each.value
  sa          = module.saccount.manager_credentials
  depends_on = [
    module.saccount.manager_credentials,
    module.cluster.ccloud_cluster
  ]
}
