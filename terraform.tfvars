environment = "env-zp5p7"

cluster = {
  display_name = "standard-inventory"
  availability = "SINGLE_ZONE"
  cloud        = "GCP"
  region       = "europe-west3"
  type         = "STANDARD" # BASIC / STANDARD
}

service_account_manager = "mcolomer-sa-man"

service_accounts = ["mcolomer-producer-sa", "mcolomer-producer-customer-sa"]

#confluent_cli_consumer_*
service_accounts_cli_group = ["mcolomer-consumer-sa" ,"mcolomer-cons-sa" ]
 
#Topic 
#DeveloperWrite
#DeveloperRead
topics = [
  {
    name     = "mcolomer-orders"
    producer = "mcolomer-producer-sa",  
    consumer = "mcolomer-consumer-sa"  
  },
  {
    name     = "mcolomer-inventory"
    producer = "mcolomer-producer-sa",
    consumer = "mcolomer-consumer-sa"
  },
  {
    name     = "mcolomer-customers"
    producer = "mcolomer-producer-customer-sa",
    consumer = "mcolomer-consumer-sa"
  }
]

