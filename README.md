# Learn Terraform - Provision an EKS Cluster

This repo is a companion repo to the [Provision an EKS Cluster tutorial](https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks), containing
Terraform configuration files to provision an EKS cluster on AWS.

# Provision Infra
```bash
tf init
tf plan
tf apply 
tf destroy
```

# Login to K8s
```bash
aws eks --region $(terraform output -raw region) update-kubeconfig \
    --name $(terraform output -raw cluster_name)
```

# Login to Mongo VM

`ssh -i "yatin-key-pair.pem" bitnami@xx.xxx.xx.xx`

# Mongo

### Get password from EC2 -> Monitor -> Get Systemlog
- Login `mongosh admin --username root -p --host xx.xx.xx.xx`
- Add user `db.createUser( { user: "dbuser", pwd: "passw0rd", roles: [ "readWrite", "dbAdmin" ]} )`
- Update backup script with correct password
- TODO: Cron job

