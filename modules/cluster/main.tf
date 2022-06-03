 
# Update the config to use a cloud provider and region of your choice.
# https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/confluent_kafka_cluster
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
 
  environment {
    id = var.environment
  }
}

 