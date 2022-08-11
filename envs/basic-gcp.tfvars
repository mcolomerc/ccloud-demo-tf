environment = "env-w75k5w"

clusters = [
  {
    display_name = "basic-inventory"
    availability = "SINGLE_ZONE"
    cloud        = "GCP"
    region       = "europe-west3"
    type         = "BASIC" # BASIC / STANDARD / DEDICATED

    serv_account_admin = {
      name = "mcolomer-sa-man"
      role = "CloudClusterAdmin"
    }
  
    topics = [
      {
        name = "mcolomer-orders"
      },
      {
        name = "mcolomer-inventory"
      }, 
      {
        name = "mcolomer-products"
      }, 
      {
        name = "mcolomer-customers"
      }
    ] 
  }
]
