 
# Update the config to use a cloud provider and region of your choice.
# https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/confluent_kafka_cluster
resource "confluent_kafka_cluster" "standard" {
  display_name = var.cluster.display_name
  availability = var.cluster.availability
  cloud        = var.cluster.cloud
  region       = var.cluster.region
  standard {}
  environment {
    id = var.environment
  }
}
