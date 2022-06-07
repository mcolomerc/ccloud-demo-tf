variable "environment" {
  type = string
}

variable "cluster" {
  type = object({
    display_name = string
    availability = string
    cloud        = string
    region       = string
    type         = string
  })
  validation {
    condition     = contains(["SINGLE_ZONE", "MULTI_ZONE"], var.cluster.availability) && contains(["GCP", "AWS", "AZURE"], var.cluster.cloud) && contains(["BASIC", "STANDARD"], var.cluster.type)
    error_message = "cluster.availability => SINGLE_ZONE or MULTI_ZONE, cluster.cloud => GCP, AWS or AZURE, cluster.type => BASIC or STANDARD"
  }
}

variable "service_account_manager" {
  type = string
}

variable "service_accounts" {
  type = list(string)
}

variable "service_accounts_cli_group" {
  type = list(string)
}

variable "topics" {
  type = list(object({
    name     = string
    consumer = optional(string)
    producer = optional(string)
  }))
}

