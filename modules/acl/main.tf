data "confluent_kafka_cluster" "kafka_cluster_acl" {
  id = var.cluster
  environment {
    id = var.environment
  }
}

data "confluent_service_account" "acl_sa" { 
  display_name = var.service_account
}

resource "confluent_kafka_acl" "acl" {
  kafka_cluster {
    id = data.confluent_kafka_cluster.kafka_cluster_acl.id
  }
  resource_type = var.resource_type
  resource_name = var.resource_name
  pattern_type  = var.pattern_type
  principal     = "User:${data.confluent_service_account.acl_sa.id}"
  host          = "*"
  operation     = var.operation
  permission    = var.permission
  rest_endpoint = data.confluent_kafka_cluster.kafka_cluster_acl.rest_endpoint
  credentials {
    key    = var.admin_sa.id
    secret = var.admin_sa.secret
  }
}
