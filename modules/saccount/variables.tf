variable "environment" {
  type = string
}

variable "cluster" {
  type = string
}

variable "service_account_manager" {
  type = string
}

variable "service_accounts" {
  type = list(string) 
}

variable "service_accounts_cli_group" {
  type = list(string) 
}
 
variable "rbac_enabled" {
  type = bool
}


