 data "confluent_environment" "connenv" {
  id = var.environment
}

data "confluent_kafka_cluster" "conncluster" {
  id = var.cluster
  environment {
    id = data.confluent_environment.connenv.id
  }
}

data "confluent_service_account" "connserv_account" {
  display_name = var.service_account
}

data "confluent_kafka_topic" "sourcetopic" {
  kafka_cluster {
    id = data.confluent_kafka_cluster.conncluster.id
  }

  topic_name    = var.topic
  http_endpoint = data.confluent_kafka_cluster.conncluster.http_endpoint

  credentials {
    key    = var.admin_sa.id
    secret = var.admin_sa.secret
  }
} 

locals {  
    dyn_config = {
        "kafka.auth.mode"          = "SERVICE_ACCOUNT"
        "kafka.service.account.id" = data.confluent_service_account.connserv_account.id
        "kafka.topic"              = data.confluent_kafka_topic.sourcetopic.topic_name
    }
    merged_config = merge(var.config, local.dyn_config)
}

resource "confluent_connector" "source" {
  environment {
    id = data.confluent_environment.connenv.id
  }
  kafka_cluster {
    id = data.confluent_kafka_cluster.conncluster.id
  }

  config_sensitive = {}

  config_nonsensitive = local.merged_config

}