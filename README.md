Project Title
=====================
This project is intended to provision infrastructure on GCP.

Pre-Requisites
============================
* Step 1: Download terraform utility
```
https://www.terraform.io/downloads) -> unzip file -> terraform.exe
```
* Step 2: Edit the system environment variables
```
System variables -> click on Path -> enter terraform.exe file path -> New -> Ok 
```
* Step 3: Authentication to GCP
 ```
Service account creation=> IAM -> Service accounts -> create service account -> service account name : mysa -> click on CREATE AND CONTINUE ->  select a role -> Basic : owner -> continue -> done -> click on service account -> keys -> add key
```
```
Create project=>(till now I am unable to create project using terraform due to permission issue)
```
```
Permission to authenticate GCP APIs => APIs & Services: enabled APIs & Services => click on ENABLE APIS AND SERVICES => Compute Engine API and Cloud SQL Admin API
```
```
export GOOGLE_APPLICATION_CREDENTIALS=~/Downloads/gcp_cred.json
```
# Execution Flow

* Step 1: clone repo
```
git clone https://github.com/cloudstonesorg/cloudstones-provisioner && cd cloudstones-provisioner/gcp-terraform
```
* Step 2: Modify stone config as per requirement in gcp_dev_stone.json
```
vi clutser-templates/gcp_dev_stone.json
ssh-keygen
cat ~/.ssh/id_rsa.pub
```
* Step 3: Provision infra
```
terraform init 
terraform apply --var-file=gcp_dev_stone.json
```
* Step 4: Post provision steps
```
login to bastionhost
eval `ssh-agent` && ssh-add -k ~/.ssh/id_rsa && ssh -A gcp-user@PUBLIC_IP
login to appserver
sudo su -l
sudo yum install python3-pip -y && sudo pip3 install gunicorn && sudo pip3 install django
sudo vi /usr/local/lib64/python3.6/site-packages/django/db/backends/sqlite3/base.py (line 67 replace > with ==)
sudo yum install git -y && sudo git clone https://github.com/devops2023q2/webapp.git && cd webapp && sudo pip3 install -r requirements.txt
gunicorn main.wsgi --bind 0.0.0.0:8000
```
* Step 5: Testing
```
lb_ip:8000
```
# Features
* Step 1: Networking
```
VPC Networks, Subnets, Router, Routes, Public Ips, Network Interface, NAT gateway, Interconnect, Private Link, VPC Peering
```
* Step 2: Security
```
IAM: Service Accounts, Roles, Quotas & System Limits, Firewalls, Secret Manager
```
* Step 3: Storage
```
Snapshots, Images, Block Storage: Disks, Blob Storage: Cloud Storage
```
* Step 4: Compute
```
VM Instances, Application Loadbalaner & Network Loadbalancer, Instance Groups, Instance Templates
```
* Step 5: Databases
```
SQL, Bigtable
```
* Step 6: Observability: Logging and Monitoring
```
Logs Explorer, Metrics Explorer
```
