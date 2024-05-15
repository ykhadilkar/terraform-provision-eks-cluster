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
# Mongo
- Login `mongosh admin --username root -p --host xx.xx.xx.xx`
- Add user `db.createUser( { user: "dbuser", pwd: "xxxxxx", roles: [ "readWrite", "dbAdmin" ]} )`


# Login to Mongo

Get password from EC2 -> Monitor -> Get Systemlog

`mongosh admin --username root -p --host <host-ip>`
