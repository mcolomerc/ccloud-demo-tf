variable "environment" {
  type = string
}

variable "cluster" {
  type = string
}

variable "rbac_enabled" {
  type = bool
}

variable "topic" {
  type = object({
    name     = string
    consumer = optional(string)
    producer = optional(string)
  })
}

variable "admin_sa" {
  type = object({
    id     = string
    secret = string
  })
}

