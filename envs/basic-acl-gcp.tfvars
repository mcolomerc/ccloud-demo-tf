environment = "env-w75k5w"

clusters = [
  {
    display_name = "basic-acl-test"
    availability = "SINGLE_ZONE"
    cloud        = "GCP"
    region       = "europe-west3"
    type         = "BASIC" # BASIC / STANDARD / DEDICATED

    serv_account_admin = {
      name = "mcolomer-sa-man-acl"
      role = "CloudClusterAdmin"
    }

    serv_accounts = [
      {
        name = "mcolomer-producer-sa"
      }
    ]

    topics = [
      {
        name = "mcolomer-orders"
      },
      {
        name = "mcolomer-inventory"
      }
    ]

    acls = [
      {
        resource_type   = "TOPIC"
        resource_name   = "mcolomer-orders"
        service_account = "mcolomer-producer-sa"
        pattern_type    = "LITERAL"  
        operation       = "WRITE"   
        permission      = "ALLOW"   
      }
    ]
  }
]

