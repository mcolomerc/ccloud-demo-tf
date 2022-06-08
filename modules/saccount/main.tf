data "confluent_environment" "env" {
  id = var.environment
}

data "confluent_kafka_cluster" "cluster" {
  id = var.cluster
  environment {
    id = data.confluent_environment.env.id
  }
}

resource "confluent_service_account" "saccount" {
  display_name = var.serv_account.name
  description  = "Service account to manage ${data.confluent_kafka_cluster.cluster.display_name} Kafka cluster"
}

resource "confluent_role_binding" "saccount_role" {
  count = var.serv_account.role != null ? 1 : 0
  principal   = "User:${confluent_service_account.saccount.id}"
  role_name   = var.serv_account.role
  crn_pattern = data.confluent_kafka_cluster.cluster.rbac_crn
  depends_on = [
    confluent_service_account.saccount
  ]
}

resource "confluent_api_key" "saccount_kafka_api_key" {
  display_name = "${var.serv_account.name}_kafka_api_key"
  description  = "Kafka API Key that is owned by ${var.serv_account.name} service account"
  owner {
    id          = confluent_service_account.saccount.id
    api_version = confluent_service_account.saccount.api_version
    kind        = confluent_service_account.saccount.kind
  }

  managed_resource {
    id          = data.confluent_kafka_cluster.cluster.id
    api_version = data.confluent_kafka_cluster.cluster.api_version
    kind        = data.confluent_kafka_cluster.cluster.kind

    environment {
      id = data.confluent_environment.env.id
    }
  }
  depends_on = [
    confluent_service_account.saccount
  ]
}
locals {
  groups = var.serv_account.groups != null ? var.serv_account.groups : []
}
resource "confluent_role_binding" "saccount_group" {
  for_each    = { for group in local.groups : group.group => group }
  principal   = "User:${confluent_service_account.saccount.id}"
  role_name   = each.value.role
  crn_pattern = "${data.confluent_kafka_cluster.cluster.rbac_crn}/kafka=${data.confluent_kafka_cluster.cluster.id}/group=${each.value.group}"
  depends_on = [
   confluent_service_account.saccount
  ]
}
