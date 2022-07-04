
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
    cku          = optional(string)
    serv_account_admin = optional(object({
      name = string
      role = string
    }))
    serv_accounts = optional(list(object({
      name = string
      role = optional(string)
      groups = optional(list(object({
        group = string
        role  = string
      })))
    })))
    topics = optional(list(object({
      name     = string
      consumer = optional(string)
      producer = optional(string)
    })))
    acls = optional(list(object({
      resource_type   = string
      resource_name   = string
      service_account = string
      pattern_type    = string  
      operation       = string
      permission      = string
    })))
    connector = optional(object({
      topic           = string
      service_account = string
      config          = map(string)
    })) 
  })
  validation {
    condition = (
      contains(["SINGLE_ZONE", "MULTI_ZONE"], var.cluster.availability)
      && contains(["GCP", "AWS", "AZURE"], var.cluster.cloud)
      && contains(["BASIC", "STANDARD", "DEDICATED"], var.cluster.type)
      && (var.cluster.type == "DEDICATED" ? var.cluster.type == "DEDICATED" && var.cluster.cku != null : true)
    )
    error_message = <<EOT
- cluster.availability => SINGLE_ZONE or MULTI_ZONE 
- cluster.cloud => GCP, AWS or AZURE 
- cluster.type => BASIC or STANDARD or DEDICATED
- for DEDICATED clusters, cluster.cku must be set
    EOT
  }
}
