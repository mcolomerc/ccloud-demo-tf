variable "environment" {
    default = "default"
    type = string
} 

variable "cluster" {
    type = object({
        display_name = string
        availability = string
        cloud        = string
        region       = string 
    })
    default = {
        display_name = "inventory"
        availability = "SINGLE_ZONE"
        cloud        = "GCP"
        region       = "europe-west3" 
    }
    validation {
       condition = contains (["SINGLE_ZONE", "MULTI_ZONE"], var.cluster.availability) && contains(["GCP", "AWS", "AZURE"], var.cluster.cloud)
       error_message = "cluster.availability and cluster.cloud must be set to SINGLE_ZONE or MULTI_ZONE and GCP, AWS or AZURE"
    }
}

variable "service_account_manager" { 
    type = string
}

variable "service_accounts" {
    type = list(string)
}

variable "topics" {
   type = list(object({
       name = string 
       consumer = string
       producer = string 
   }))
} 

