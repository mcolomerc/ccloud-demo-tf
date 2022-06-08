environment = "env-zp5p7"

cluster = {
  display_name = "basic-inventory"
  availability = "SINGLE_ZONE"
  cloud        = "GCP"
  region       = "europe-west3"
  type         = "BASIC" # BASIC / STANDARD
}

service_account_manager = "mcolomer-sa-manager"
 
topics = [
  {
    name     = "mcolomer-orders" 
  },
  {
    name     = "mcolomer-inventory" 
  },
  {
    name     = "mcolomer-customers" 
  }
]
 
connector_deploy = false s 