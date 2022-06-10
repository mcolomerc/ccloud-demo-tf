
data "confluent_environment" "environment" {
  id = var.environment
}

module "cluster" {
  for_each    = { for cluster in var.clusters : cluster.display_name => cluster }
  source      = "./modules/cluster"
  environment = data.confluent_environment.environment.id
  cluster     = each.value
}
 