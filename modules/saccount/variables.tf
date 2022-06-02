variable "environment" {
    default = "default"
}

variable "cluster"  {
    type = string
}
  
variable "service_account_manager" {
    default = "app-manager"
}

variable "service_accounts" {
    type = list(string)
} 

