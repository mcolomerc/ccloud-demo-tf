variable "environment" {
  type = string
}

variable "cluster" {
  type = string
}
 
variable "rbac_enabled" {
  type = bool
}

variable "serv_account" {
  type = object({
    name  = string
    role = optional(string) 
    groups = optional(list(object ({
      group = string
      role = string
    })))
  })
}

