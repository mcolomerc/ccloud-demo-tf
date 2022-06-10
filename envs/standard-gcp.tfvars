environment = "env-zp5p7"

clusters = [
  {
    display_name = "mcolomer-standard-inventory"
    availability = "SINGLE_ZONE"
    cloud        = "GCP"
    region       = "europe-west3"
    type         = "STANDARD" # BASIC / STANDARD / DEDICATED

    serv_account_admin = {
      name = "mcolomer-sa-man"
      role = "CloudClusterAdmin"
    }

    serv_accounts = [
      {
        name = "mcolomer-producer-sa"
      },
      {
        name = "mcolomer-consumer-sa"
        groups = [
          {
            group = "confluent_cli_consumer_*",
            role  = "DeveloperRead"
          }
        ]
      }
    ] 
  }
]
