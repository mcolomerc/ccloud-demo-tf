variable "environment" {
    default = "default"
}

variable "cluster"  {
    type = string
}

variable "topic" {
   type = object({
       name = string 
       consumer = string
       producer = string 
   })
} 

variable "sa" {
  type = object({
    id     = string
    secret = string
  })
}

