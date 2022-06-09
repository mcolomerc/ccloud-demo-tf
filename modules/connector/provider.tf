terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "0.10.0"
    }
  }
   experiments = [module_variable_optional_attrs]
}
 
