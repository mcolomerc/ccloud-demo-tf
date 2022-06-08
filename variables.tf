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

variable "serv_account_admin" {
  type = object({
    name = string
    role = string
  })
}

variable "serv_accounts" {
  type = list(object({
    name = string
    role = optional(string)
    groups = optional(list(object({
      group = string
      role  = string
    })))
  }))
}

variable "topics" {
  type = list(object({
    name     = string
    consumer = optional(string)
    producer = optional(string)
  }))
}

/* **************** */
/* *** Connector ** */
variable "connector_deploy" {
  type = bool
}
variable "connector" {
  type = object({
    topic           = string
    service_account = string
    config          = map(string)
  })
  default = {
    topic           = "mcolomer-orders"
    service_account = "mcolomer-producer-sa"
    config = {
      "connector.class"    = "DatagenSource"
      "name"               = "DatagenSourceConnector_0"
      "output.data.format" = "JSON"
      "quickstart"         = "ORDERS"
      "tasks.max"          = "1"
    }
  }
}

