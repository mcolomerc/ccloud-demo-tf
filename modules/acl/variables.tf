variable "environment" {
  type = string
}

variable "cluster" {
  type = string
}

variable "admin_sa" {
  type = object({
    id     = string
    secret = string
  })
}

variable "service_account" {
  type = string
}

variable "resource_type" {
    type = string
    validation {
    condition = (
      contains(["UNKNOWN", "ANY", "TOPIC", "GROUP", "CLUSTER", "TRANSACTIONAL_ID", "DELEGATION_TOKEN"], var.resource_type) 
    )
    error_message = <<EOT
    ACL:
- resource_type => UNKNOWN, ANY, TOPIC, GROUP, CLUSTER, TRANSACTIONAL_ID, DELEGATION_TOKEN 
  https://docs.confluent.io/platform/current/kafka/authorization.html#using-acls
    EOT
  }
}

variable "resource_name" {
  type = string
}

variable "pattern_type" {
    type = string
    validation {
    condition = contains(["UNKNOWN","ANY","MATCH","LITERAL","PREFIXED"], var.pattern_type)  
    error_message = <<EOT
    ACL:
- pattern_type => UNKNOWN, ANY, MATCH, LITERAL, PREFIXED
  https://docs.confluent.io/platform/current/kafka/authorization.html#using-acls
    EOT
  }
}

variable "operation" {
    type = string
    validation {
    condition = (
      contains(["UNKNOWN", "ANY", "ALL", "READ", "WRITE", "CREATE", "DELETE", "ALTER", "DESCRIBE", "CLUSTER_ACTION", "DESCRIBE_CONFIGS", "ALTER_CONFIGS", "IDEMPOTENT_WRITE"], var.operation) 
    )
    error_message = <<EOT
    ACL:
- operation => UNKNOWN, ANY, ALL, READ, WRITE, CREATE, DELETE, ALTER, DESCRIBE, CLUSTER_ACTION, DESCRIBE_CONFIGS, ALTER_CONFIGS, IDEMPOTENT_WRITE
  https://docs.confluent.io/platform/current/kafka/authorization.html#using-acls
    EOT
  }
}

variable "permission" {
    type = string
    validation {
    condition = (
      contains(["UNKNOWN", "ANY", "ALLOW", "DENY"], var.permission) 
    )
    error_message = <<EOT
    ACL:
    - permission => UNKNOWN, ANY, ALLOW, DENY
    https://docs.confluent.io/platform/current/kafka/authorization.html#using-acls
    EOT
    }
}

 