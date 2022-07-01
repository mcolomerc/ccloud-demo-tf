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

provider "confluent" {}

/* provider "confluent" {
  api_key    = var.confluent_cloud_api_key
  api_secret = var.confluent_cloud_api_secret
} */

#  CONFLUENT_CLOUD_API_KEY env var
#  CONFLUENT_CLOUD_API_SECRET env var