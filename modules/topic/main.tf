
data "confluent_kafka_cluster" "kafka_cluster" {
  id = var.cluster
  environment {
    id = var.environment
  }
}

resource "confluent_kafka_topic" "topic" {
   
  kafka_cluster {
    id = data.confluent_kafka_cluster.kafka_cluster.id
  }

  topic_name    = var.topic.name
  http_endpoint = data.confluent_kafka_cluster.kafka_cluster.http_endpoint
  credentials {
    key    = var.sa.id
    secret = var.sa.secret
  }
} 

//RBAC 

data "confluent_service_account" "producer" {
  count = var.rbac_enabled == true ? 1 : 0
  display_name = var.topic.producer
}

data "confluent_service_account" "consumer" {
  count = var.rbac_enabled == true ? 1 : 0
  display_name = var.topic.consumer
}

// Role binding for the Kafka cluster 
resource "confluent_role_binding" "app-producer-developer-read-from-topic" {
  count = var.rbac_enabled == true ? 1 : 0
  principal   = "User:${data.confluent_service_account.consumer[count.index].id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${data.confluent_kafka_cluster.kafka_cluster.rbac_crn}/kafka=${data.confluent_kafka_cluster.kafka_cluster.id}/topic=${confluent_kafka_topic.topic.topic_name}"
}

resource "confluent_role_binding" "app-producer-developer-read-from-group" {
  count = var.rbac_enabled == true ? 1 : 0
  principal = "User:${data.confluent_service_account.consumer[count.index].id}"
  role_name = "DeveloperRead"
  crn_pattern = "${data.confluent_kafka_cluster.kafka_cluster.rbac_crn}/kafka=${data.confluent_kafka_cluster.kafka_cluster.id}/group=confluent_cli_consumer_*"
}  

resource "confluent_role_binding" "app-producer-developer-write" {
  count = var.rbac_enabled == true ? 1 : 0
  principal   = "User:${data.confluent_service_account.producer[count.index].id}"
  role_name   = "DeveloperWrite"
  crn_pattern = "${data.confluent_kafka_cluster.kafka_cluster.rbac_crn}/kafka=${data.confluent_kafka_cluster.kafka_cluster.id}/topic=${confluent_kafka_topic.topic.topic_name}"
}


