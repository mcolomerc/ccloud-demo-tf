# Configure the Confluent Cloud Provider
terraform {
  required_version = ">= 0.15.0"
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.0.0"
    }
  }
  experiments = [module_variable_optional_attrs]
}
 
