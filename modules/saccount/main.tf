data "confluent_environment" "env" {
  id = var.environment
}

data "confluent_kafka_cluster" "cluster" {
  id = var.cluster
  environment {
    id = data.confluent_environment.env.id
  }
}

resource "confluent_service_account" "app-manager" {
  display_name = var.service_account_manager
  description  = "Service account to manage ${data.confluent_kafka_cluster.cluster.display_name} Kafka cluster"
}

resource "confluent_role_binding" "app-manager-kafka-cluster-admin" {
  principal   = "User:${confluent_service_account.app-manager.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = data.confluent_kafka_cluster.cluster.rbac_crn
  depends_on = [
    confluent_service_account.app-manager
  ]
}


resource "confluent_api_key" "app-manager-kafka-api-key" {
  display_name = "${var.service_account_manager}-kafka-api-key"
  description  = "Kafka API Key that is owned by ${var.service_account_manager} service account"
  owner {
    id          = confluent_service_account.app-manager.id
    api_version = confluent_service_account.app-manager.api_version
    kind        = confluent_service_account.app-manager.kind
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
    confluent_role_binding.app-manager-kafka-cluster-admin
  ]
}

locals {
  sa_accounts = var.rbac_enabled == true ? toset(var.service_accounts) : toset([])
  sa_accounts_groups = var.rbac_enabled == true ? toset(var.service_accounts_cli_group) : toset([])
}

## SERVICE ACCOUNTs 
resource "confluent_service_account" "sa" {
  for_each     = local.sa_accounts
  display_name = each.value
  description  = "Service account ${each.value} - ${data.confluent_kafka_cluster.cluster.id} Kafka cluster"
}

resource "confluent_api_key" "sa-kafka-api-key" {
  for_each     = confluent_service_account.sa
  display_name = "${each.value.id}-kafka-api-key"
  description  = "Kafka API Key that is owned by ${each.value.id} service account"
  owner {
    id          = each.value.id
    api_version = each.value.api_version
    kind        = each.value.kind
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
    confluent_service_account.sa
  ]
}

## SERVICE ACCOUNTs - GROUPS

resource "confluent_service_account" "sa_group" {
  for_each     = local.sa_accounts_groups
  display_name = each.value
  description  = "Service account ${each.value} - ${data.confluent_kafka_cluster.cluster.id} Kafka cluster"
}

resource "confluent_api_key" "sa-group-kafka-api-key" {
  for_each     = confluent_service_account.sa_group
  display_name = "${each.value.id}-kafka-api-key"
  description  = "Kafka API Key that is owned by ${each.value.id} service account"
  owner {
    id          = each.value.id
    api_version = each.value.api_version
    kind        = each.value.kind
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
    confluent_service_account.sa_group
  ]
}

resource "confluent_role_binding" "app-consumer-developer-read-from-group" { 
  for_each     = confluent_service_account.sa_group
  principal   = "User:${each.value.id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${data.confluent_kafka_cluster.cluster.rbac_crn}/kafka=${data.confluent_kafka_cluster.cluster.id}/group=confluent_cli_consumer_*"
  depends_on = [
    confluent_api_key.sa-group-kafka-api-key
  ]
}
