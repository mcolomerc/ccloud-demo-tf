
variable "environment" {
  type = string
}

variable "cluster" {
  type = object({
    display_name = string
    availability = string
    cloud        = string
    region       = string
  })
}
