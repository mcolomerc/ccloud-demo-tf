environment = "env-zp5p7"

cluster = {
  display_name = "mcolomer-standard-inventory"
  availability = "SINGLE_ZONE"
  cloud        = "GCP"
  region       = "europe-west3"
  type         = "STANDARD" # BASIC / STANDARD
}

serv_account_admin = {
  name = "mcolomer-sa-man"
  role = "CloudClusterAdmin"  
} 

serv_accounts = [ 
  {
    name = "mcolomer-producer-sa"  
  },
  {
    name   = "mcolomer-consumer-sa"  
    groups = [
      { 
        group = "confluent_cli_consumer_*", 
        role = "DeveloperRead" 
      }
    ]
  } 
]

#Topic 
#DeveloperWrite
#DeveloperRead
topics = [
  {
    name     = "mcolomer-orders"
    producer = "mcolomer-producer-sa",
    consumer = "mcolomer-consumer-sa"
  } 
]

/* Connector */
connector_deploy = true 

connector = {
  topic = "mcolomer-orders"
  service_account  = "mcolomer-producer-sa"
  config = {
    "connector.class"          = "DatagenSource"
    "name"                     = "DatagenSourceConnector_tf" 
    "output.data.format"       = "JSON"
    "quickstart"               = "ORDERS"
    "tasks.max"                = "1"
  }
} 