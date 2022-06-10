environment = "env-w75k5w"

clusters = [
  {
    display_name = "mango-dedicated-inventory-0"
    availability = "SINGLE_ZONE"
    cloud        = "GCP"
    region       = "europe-west3"
    type         = "DEDICATED" # BASIC / STANDARD / DEDICATED
    cku          = 1 # CKU required for DEDICATED
    serv_account_admin = {
      name = "mango-sa-man"
      role = "CloudClusterAdmin"
    } 
    serv_accounts = [
      {
        name = "mango-producer-sa"
      },
      {
        name = "mango-consumer-sa"
        groups = [
          {
            group = "confluent_cli_consumer_*",
            role  = "DeveloperRead"
          }
        ]
      }
    ] # end serv_accounts
    topics = [
      {
        name     = "mango-orders"
        producer = "mango-producer-sa",
        consumer = "mango-consumer-sa"
      }
    ]  # end topics
  } # end of cluster
]
 
