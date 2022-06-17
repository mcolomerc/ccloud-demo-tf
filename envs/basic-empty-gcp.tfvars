environment = "env-w75k5w"

clusters = [
  {
    display_name = "basic-cevents"
    availability = "SINGLE_ZONE"
    cloud        = "GCP"
    region       = "europe-west3"
    type         = "BASIC" # BASIC / STANDARD / DEDICATED 

    serv_account_admin = {
      name = "mcolomer-sa-man"
      role = "CloudClusterAdmin"
    }
  }
]
