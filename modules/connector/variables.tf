variable "environment" {
  type = string
}

variable "cluster" {
  type = string
}

variable "topic" {
  type = string
}

variable "service_account" {
  type = string
}

variable "config" {
  type = map(string)
  default = {
    "connector.class"          = "DatagenSource"
    "name"                     = "DatagenSourceConnector_0" 
    "output.data.format"       = "JSON"
    "quickstart"               = "ORDERS"
    "tasks.max"                = "1"
  }
}

variable "admin_sa" {
  type = object({
    id     = string
    secret = string
  })
}
 
