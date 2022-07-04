variable "environment" {
  type = string
}

variable "clusters" {
  type = list(object({
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
  )
}

