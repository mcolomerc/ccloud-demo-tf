# Confluent Cloud Terraform deployment

Confluent Terraform provider 
https://registry.terraform.io/providers/confluentinc/confluent/latest/docs

* Create a service account in Confluent Cloud

* Assign the OrganizationAdmin role to the service account

* Create a Cloud API Key for the service account

```
export CONFLUENT_CLOUD_API_KEY="<cloud_api_key>" 

export CONFLUENT_CLOUD_API_SECRET="<cloud_api_secret>"
```
 
## Variables 

*terraform.tfvars*

### Confluent Cloud environment

Existing Confluent Cloud Environment ID 

```
environment = "default"
```

*Terraform uses an existing environment, it wont create a new environment if it does not exist*.

### Cluster 

#### Basic Cluster

Cluster properties:

- **availability**: must be set to SINGLE_ZONE or MULTI_ZONE 
- **cloud**: must be set to GCP, AWS or AZURE

```
cluster = {
    display_name = "basic-inventory"
    availability = "SINGLE_ZONE"
    cloud        = "GCP"
    region       = "europe-west3"
    type         = "BASIC"  
}
``` 

#### Standard Cluster

Cluster properties:

- **availability**: must be set to SINGLE_ZONE or MULTI_ZONE 
- **cloud**: must be set to GCP, AWS or AZURE

```
cluster = {
    display_name = "inventory"
    availability = "SINGLE_ZONE"
    cloud        = "GCP"
    region       = "europe-west3"
    type         = "STANDARD"  
}
``` 

### Service Accounts

- Service account is required in this configuration to create topics and assign roles

```
service_account_manager = "mcolomer-sa-manager"
```

- RBAC 

* RBAC is not supported in Confluent Cloud Basic Cluster. 
    
* Standard cluster: Service account to consume or produce messages from/to topics:
 
```
service_accounts = ["mcolomer-producer-sa", "mcolomer-consumer-sa", "mcolomer-producer-customer-sa"]
```

### Topics
 
A list of topics to create:

#### Basic Cluster 

Each object:

- name: Topic name  

```
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

#### Standard Cluster 

Each object:  

- name: Topic name 
- consumer: Service account to consume
- producer: Service account to produce 

```
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

### Examples 
 
  * Basic GCP Cluster: ./envs/basic-gcp.tfvars

  * Standard GCP Cluster: ./envs/standard-gcp.tfvars  

## Terraform 

* Initialize the Terraform environment:

```
terraform init 
```

* Validate 

```
terraform validate 
```

* Deploy  

```
terraform plan --var-file=./envs/standard-gcp.tfvars
```

```
terraform apply --var-file=./envs/standard-gcp.tfvars
```

* Get sensistivie information about the accounts: 

    - Service account manager
    - Service accounts to consume messages from topics

    ```
    terraform output sas
    ```

* Clean Up 

```
terraform destroy 
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
````

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
