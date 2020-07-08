# Sugarizer School Portal Chart
[Helm](https://helm.sh/) Chart for setting up [Sugarizer School Portal Server](https://github.com/nikhilm98/sugarizer-school-portal-server) deployment on a [Kubernetes](https://kubernetes.io/) cluster.

**Sugarizer School Portal** is a Kubernetes cluster that is able to create/manage on-demand new Sugarizer Server instances.

## Usage
You can deploy **Sugarizer School Portal Server** instance by editing the values of the Values YAML file and running simple `helm install` command. The Sugarizer School Portal Server instance can be accessed by the browser by opening the hostName URL.

## Environment Setup
If you don't have a [GKE](https://cloud.google.com/kubernetes-engine) cluster set-up, you can follow these steps to set-up a working environment.

### Install MongoDB-Replicaset
You can install MongoDB-Replicaset using [MongoDB-Replicaset](https://github.com/helm/charts/tree/master/stable/mongodb-replicaset) Helm Chart.
MongoDB-Replicaset can be installed by following these commands:
```bash
# Add Chart Repository
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update

# Install the chart with the release name mymongodb (You can change the release name)
helm install mymongodb stable/mongodb-replicaset
```

### Install Kubernetes-Reflector
[Reflector](https://github.com/emberstack/kubernetes-reflector) is a Kubernetes addon designed to monitor changes to resources (secrets and configmaps) and reflect changes to mirror resources in the same or other namespaces. Reflector includes a cert-manager extension used to automatically annotate created secrets and allow reflection.    
You can install Reflector using its Helm Chart. It can be installed by following these commands:
```bash
# Add Chart Repository
helm repo add emberstack https://emberstack.github.io/helm-charts
helm repo update

# Install the chart with the release name reflector (You can change the release name)
helm upgrade --install reflector emberstack/reflector
```

### Install NGINX Ingress Controller
The [NGINX Ingress Controller](https://github.com/nginxinc/kubernetes-ingress/) provides an implementation of an Ingress controller for NGINX and NGINX Plus.

The Ingress is a Kubernetes resource that lets you configure an HTTP load balancer for applications running on Kubernetes, represented by one or more Services. Such a load balancer is necessary to deliver those applications to clients outside of the Kubernetes cluster.

Clone the chart repository:
```bash
git clone https://github.com/nginxinc/kubernetes-ingress/
cd deployments/helm-chart/
```
Open the `values.yaml` file and add these `customPorts` under `controller.service.customPorts`:
```bash
customPorts:
  - port: 8039
    targetPort: https
    protocol: TCP
    name: presence
```
Install the chart with the release name nginx-ingress (You can change the release name)
```bash
helm install nginx-ingress .
```

### Install Cert-Manager
[Cert-Manager](https://cert-manager.io/docs/) is a native Kubernetes certificate management controller. It can help with issuing certificates from a variety of sources, such as Let’s Encrypt, HashiCorp Vault, Venafi, a simple signing key pair, or self-signed.

We use Cert-Manager to issue HTTPS certificates to the Sugarizer School Portal Server and its Sugarizer-Server deployments.

You can refer to Cert-Manager [installation documentation](https://cert-manager.io/docs/installation/kubernetes/) or simply follow these commands to install Cert-Manager on the cluster:
```bash
# Create the namespace for cert-manager
kubectl create namespace cert-manager

# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Cert-Manager requires a number of CRD resources to be installed into your cluster as part of installation.
# Install CRDs as part of the Helm release
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v0.15.1 --set installCRDs=true
```

### Create Service Account
You need to create a GCP service account key from the API & Services page. Save the service account key. It will be required in the values.yaml file while chart installation. It'll also be required if you set-up backup and restore using MGOB and intend to use gcloud bucket.

## Chart Installation
If you have Kubernetes set-up, then Sugarizer School Portal Chart can be installed by following these steps:

### Clone Sugarizer School Portal Chart
```bash
git clone https://github.com/NikhilM98/sugarizer-school-portal-chart
```

### Edit Default Values
Open [values.yaml](values.yaml) and edit the default values.

**sspNamespace:** Kubernetes [Namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/) for the chart. It is the namespace on which Sugarizer School Portal Server will be installed.

**hostName:** The hostname from which Sugarizer School Portal Server will be accessible. Must be a valid domain/subdomain. Must be a valid hostname as defined in [RFC 1123](https://tools.ietf.org/html/rfc1123).

**host:** The host on which new Sugarizer-Server deployments will be available as subdomain. The Sugarizer-Server deployments will be available on `<schoolShortName>.host`. For example if schoolShortName is `test` and host is `sugarizer.tools` then the deployment will be available on `test.sugarizer.tools`.

**databaseUrl:** The URL of the MongoDB database. If replicaset is used, it can be the name of your replicaset like `mymongodb` which maps to `mymongodb-mongodb-replicaset-0.mymongodb-mongodb-replicaset.default.svc.cluster.local:27017,mymongodb-mongodb-replicaset-1.mymongodb-mongodb-replicaset.default.svc.cluster.local:27017,mymongodb-mongodb-replicaset-2.mymongodb-mongodb-replicaset.default.svc.cluster.local:27017` in the .ini file or if a single database without replicaset is used, then it can be like `sugarizer-service-db-mymongodb.sugarizer-mymongodb.svc.cluster.local`.

**replicaset:** Boolean. Defines if databaseUrl is the URL of a replicaset or a single database. Set it to `true` if MongoDB replicaset chart is used. `false` if database is used without replicasets.

**gcpProjectId:** The Project ID of the project on Google Cloud Platform.

**clouddns:** Your service account key in base64 format.

### Install Chart Using Helm
Navigate into the chart directory and run:
```bash
helm install ssp .
```
Where `ssp` can be the name you want to give to this chart.

## Backup and Restore data using MGOB
[MGOB](https://github.com/stefanprodan/mgob/) is a MongoDB backup automation tool built with Go. It features like scheduled backups, local backups retention, upload to S3 Object Storage (Minio, AWS, Google Cloud, Azure) and upload to gcloud storage.

To setup MGOB to automate MongoDB backups on Google Kubernetes Engine, follow these step by step instructions:

Requirements:
- GKE cluster minimum version v1.8
- kubctl admin config

### Store Service Account key as a secret
First, you need to create a GCP service account key from the API & Services page. In case you already have one, then download the JSON file and rename it to `key.json`.

Store the JSON file as a secret:
```bash
kubectl create secret generic service-acc-secret --from-file=key.json
```

### MGOB Installation
Clone the MGOB repository:
```bash
git clone https://github.com/stefanprodan/mgob.git
cd mgob/chart
```
Edit the chart's `values.yaml` file.
- Set the appropriate `storageClass` for your provider.
- Update the `mgob-config` `configMap`. Add `sugarizer-database` backup plan.
Here is an example backup plan:
```bash
sugarizer-database.yml: |
  target:
    host: "mymongodb-mongodb-replicaset-0.mymongodb-mongodb-replicaset.default,mymongodb-mongodb-replicaset-1.mymongodb-mongodb-replicaset.default,mymongodb-mongodb-replicaset-2.mymongodb-mongodb-replicaset.default"
    port: 27017
    database: ""
  scheduler:
    cron: "0 0,6,12,18 */1 * *"
    retention: 14
    timeout: 60
```
- Add a reference to the secret. You can either insert your secret values as part of helm values or refer externally created secrets. In our case, we created a secret with a name `service-acc-secret`.
```bash
secret:
  - name: service-acc-secret
```
An example YAML configuration is available as [mgob-gke.yaml](examples/mgob-gke.yaml).

### Backup to GCP Storage Bucket (Optional)
For long term backup storage, you could use a GCP Bucket since is a cheaper option than keeping all backups on disk.    
You need to enable `storage.objects` acccess to the service account in order to allow objects creation in the bucket.    
From the GCP web UI, navigate to Storage and create a regional bucket named `ssp-backup` (Or any other name if it's taken). Set the bucket and secret name in the backup-plan in the `values.yaml` file.
```bash
gcloud:
  bucket: "ssp-backup"
  keyFilePath: /secret/service-acc-secret/key.json
```

### Restoring data from backup
In order to restore data to the Sugarizer School Portal database, you need to open a shell in MGOB pod. The backups are available in `/storage/sugarizer-database/` directory inside the pod (where `sugarizer-database` was the name of our backup plan).

- In case of a database error in which you need to completely restore all the databases, you can run:
```bash
mongorestore --gzip --archive=/storage/sugarizer-database/sugarizer-database-xxxxxxxxxx.gz --host mymongodb-mongodb-replicaset-0.mymongodb-mongodb-replicaset.default:27017 --drop
```
- In case a school's DB is messed up and you need to restore that, you can run:
```bash
mongorestore --gzip --archive=/storage/sugarizer-database/sugarizer-database-xxxxxxxxxx.gz --nsInclude="db_name.*" --host mymongodb-mongodb-replicaset-0.mymongodb-mongodb-replicaset.default:27017 --drop
```
Where db_name is the name of the database to restore.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
This project is licensed under `Apache v2` License. See [LICENSE](LICENSE) for full license text.

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
