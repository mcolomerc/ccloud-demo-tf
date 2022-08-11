# Confluent Cloud Terraform deployment

Create Confluent Cloud clusters using Terraform and the [Confluent Terraform provider](https://registry.terraform.io/providers/confluentinc/confluent) 

Get started: 

* Create a service account in Confluent Cloud

* Assign the *OrganizationAdmin* role to the service account

* Create a Cloud API Key for the service account

* Setup your environment:

```sh
export CONFLUENT_CLOUD_API_KEY="<cloud_api_key>" 

export CONFLUENT_CLOUD_API_SECRET="<cloud_api_secret>"
```
 
## Variables 

### Confluent Cloud environment

Existing Confluent Cloud Environment ID 

```sh
environment = "<environment_id>"
```

*Terraform uses an existing environment, it wont create a new environment if it does not exist*.

### Cluster List

Terraform will create a new cluster for each entry in the list.

```sh
clusters = [ {
  <cluster_object>
}]
```

#### Cluster Object 

Confluent Cloud cluster type: BASIC, STANDARD or DEDICATED. 

##### Basic Cluster

Cluster properties:

- **availability**: must be set to SINGLE_ZONE or MULTI_ZONE 
- **cloud**: must be set to GCP, AWS or AZURE

```sh 
  display_name = "basic-inventory"
  availability = "SINGLE_ZONE"
  cloud        = "GCP"
  region       = "europe-west3"
  type         = "BASIC"   
``` 

##### Standard Cluster

Cluster properties:

- **availability**: must be set to SINGLE_ZONE or MULTI_ZONE 
- **cloud**: must be set to GCP, AWS or AZURE

```sh 
  display_name = "inventory"
  availability = "SINGLE_ZONE"
  cloud        = "GCP"
  region       = "europe-west3"
  type         = "STANDARD"   
``` 

##### Dedicated Cluster

- **availability**: must be set to SINGLE_ZONE or MULTI_ZONE 
- **cloud**: must be set to GCP, AWS or AZURE
- **cku** : must be set for DEDICATED clusters

```sh 
  display_name = "inventory"
  availability = "SINGLE_ZONE"
  cloud        = "GCP"
  region       = "europe-west3"
  type         = "DEDICATED"
  cku          = 1
```
 
##### Service Accounts

- Service account is required in this configuration to manage resources (create topics, assign roles, ...)

```sh
serv_account_admin = {
  name = "mcolomer-sa-man"
  role = "CloudClusterAdmin"  
}
```

- **RBAC** 

  * RBAC is not supported in Confluent Cloud Basic Cluster. 
    
  * Standard & Dedicated clusters: 
  
  Provide a Service account list to consume or produce messages from/to topics:
 
```sh   
serv_accounts = [ 
  {
    name = "mcolomer-producer-sa"  
  },
  {
    name = "mcolomer-producer-customer-sa"  
  },
  {
    name   = "mcolomer-consumer-sa"  
    groups = [
      { 
        group = "confluent_cli_consumer_*", 
        role = "DeveloperRead" 
      }
    ]
  },
  {
    name   = "mcolomer-cons-sa" 
    groups = [
      { 
        group = "confluent_cli_consumer_*", 
        role = "DeveloperRead" 
      }
    ]
  }
]
```

Groups is an optional value, if used it will add the principal to the group with specified role.

##### Topics
 
A list of topics to create: 

```sh
topics = [
    {
        name = "mcolomer-orders"  
    }, 
    {
        name = "mcolomer-inventory" 
    },
    {
        name = "mcolomer-customers" 
    }
]
```

- Topics RBAC configuration. 

Each object:  

- name: Topic name 
- consumer: Service account to consume
- producer: Service account to produce 

```sh
topics = [
{
    name = "mcolomer-orders"
    producer = "mcolomer-producer-sa",
    consumer = "mcolomer-consumer-sa"
    }, 
    {
    name = "mcolomer-inventory"
    producer = "mcolomer-producer-sa",
    consumer = "mcolomer-consumer-sa"
    },
    {
    name = "mcolomer-customers"
    producer = "mcolomer-producer-customer-sa",
    consumer = "mcolomer-consumer-sa"
    }
]
```

##### ACLs

[ACLs](https://docs.confluent.io/current/security/acl.html) are used to control access to topics.

```sh
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
```

Accepted values are:

* Resource Type: UNKNOWN, ANY, TOPIC, GROUP, CLUSTER, TRANSACTIONAL_ID, DELEGATION_TOKEN

* Pattern Type: UNKNOWN, ANY, MATCH, LITERAL, PREFIXED

* Operation: UNKNOWN, ANY, ALL, READ, WRITE, CREATE, DELETE, ALTER, DESCRIBE, CLUSTER_ACTION, DESCRIBE_CONFIGS, ALTER_CONFIGS, IDEMPOTENT_WRITE

* Permission: UNKNOWN, ANY, ALLOW, DENY


##### Connector 

Source connector configuration

* An exisiting topic
* An existing service account with grants to produce messages to the topic
* Connector configuration

 
```sh
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
```

### Examples 
 
* Basic GCP Cluster: *./envs/basic-gcp.tfvars*

* Standard GCP Cluster: *./envs/standard-gcp.tfvars* 

* Dedicated GCP Cluster: *./envs/dedicated-gcp.tfvars*

* Multiple Clusters: *./envs/multi-gcp.tfvars*

## Terraform 

* Initialize the Terraform environment:

```sh
terraform init 
```

* Validate 

```sh
terraform validate 
```

* Deploy  

Plan:

```sh
terraform plan --var-file=./envs/standard-gcp.tfvars
```

Apply:

```sh
terraform apply --var-file=./envs/standard-gcp.tfvars
```

* Get sensistivie information about the accounts: 

    - Service account manager
    - Service accounts to consume messages from topics

    ```sh
    terraform output service_accounts
    ```

* Clean Up 

```sh
terraform destroy 
```

* Enable Debug 

```sh
export TF_LOG="DEBUG"
```

* Enable log file 

```sh
export TF_LOG_PATH="./full_log.txt" 
```

## Quick test   

1. Log in to Confluent Cloud

```shell
confluent login
```

2. Produce key-value records to topic '<TOPIC_NAME>' by using <APP-PRODUCER'S NAME>'s Kafka API Key

Enter a few records and then press 'Ctrl-C' when you're done.

Sample records:

```json
 {"number":1,"date":18500,"shipping_address":"899 W Evelyn Ave, Mountain View, CA 94041, USA","cost":15.00}

 {"number":2,"date":18501,"shipping_address":"1 Bedford St, London WC2E 9HG, United Kingdom","cost":5.00}

 {"number":3,"date":18502,"shipping_address":"3307 Northland Dr Suite 400, Austin, TX 78731, USA","cost":10.00} 
```

``` 
confluent kafka topic produce <TOPIC_NAME> --environment <ENVIRONMENT_ID> \    
          --cluster <CLUSTER_ID> \
          --api-key "<APP-PRODUCER'S KAFKA API KEY>" \
          --api-secret "<APP-PRODUCER'S KAFKA API SECRET>"
```

3. Consume records from topic '<TOPIC_NAME>' by using <APP-CONSUMER'S NAME>'s Kafka API Key

```
confluent kafka topic consume <TOPIC_NAME> --from-beginning --environment <ENVIRONMENT_ID> \
          --cluster <CLUSTER_ID> \
          --api-key "<APP-CONSUMER'S KAFKA API KEY>" \
          --api-secret "<APP-CONSUMER'S KAFKA API SECRET>" 
```

When you are done, press 'Ctrl-C'.

