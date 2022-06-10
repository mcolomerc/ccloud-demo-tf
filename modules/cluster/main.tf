 
resource "confluent_kafka_cluster" "cluster" {
  display_name = var.cluster.display_name
  availability = var.cluster.availability
  cloud        = var.cluster.cloud
  region       = var.cluster.region 
  dynamic "basic" {
   for_each = upper(var.cluster.type) == "BASIC" ? [1] : [] 
   content {
     
   }
  } 
  dynamic "standard" {
    for_each = upper(var.cluster.type) ==  "STANDARD" ? [1] : []
    content {
       
    } 
  } 
  dynamic "dedicated" {
    for_each = upper(var.cluster.type) ==  "DEDICATED" ? [1] : []
    content {
       cku = var.cluster.cku
    } 
  } 
  environment {
    id = var.environment
  }
}

locals {
  rbac_enabled = upper(var.cluster.type) !=  "BASIC" ? true : false 
  saccounts = var.cluster.serv_accounts != null ? var.cluster.serv_accounts : []
  topics = var.cluster.topics != null ? var.cluster.topics : []
}

module "saccount_admins" {  
  source       = "../saccount"
  environment  = var.environment
  cluster      = confluent_kafka_cluster.cluster.id
  serv_account = var.cluster.serv_account_admin
  rbac_enabled = local.rbac_enabled
  depends_on = [
    confluent_kafka_cluster.cluster
  ]
}
 
module "saccount" {
  for_each     = { for sa in local.saccounts : sa.name => sa }
  source       = "../saccount" 
  environment  = var.environment
  cluster      = confluent_kafka_cluster.cluster.id
  serv_account = each.value
  rbac_enabled = local.rbac_enabled
  depends_on = [
    confluent_kafka_cluster.cluster
  ]
}

module "topic" {
  for_each     = { for topic in local.topics : topic.name => topic }
  source       = "../topic"
  environment  = var.environment
  cluster      = confluent_kafka_cluster.cluster.id
  topic        = each.value
  admin_sa     = module.saccount_admins.service_accounts_credentials
  rbac_enabled = local.rbac_enabled
  depends_on = [
    module.saccount_admins, 
    module.saccount.service_accounts_credentials, 
    confluent_kafka_cluster.cluster
  ]
}

module "connector" {
  count           = var.cluster.connector != null ? 1 : 0
  source          = "../connector"
  environment     = var.environment
  cluster         = confluent_kafka_cluster.cluster.id
  topic           = var.cluster.connector.topic
  service_account = var.cluster.connector.service_account
  config          = var.cluster.connector.config
  admin_sa        = module.saccount_admins.service_accounts_credentials 
  depends_on = [
    module.topic.created_topic,
    module.saccount_admins.service_accounts_credentials, 
    module.saccount.service_accounts_credentials, 
    confluent_kafka_cluster.cluster
  ]
}


 