output "ccloud_cluster" {
    value = confluent_kafka_cluster.cluster
}

output "rbac_enabled" {
    value =  upper(var.cluster.type) ==  "STANDARD" ? true : false
}