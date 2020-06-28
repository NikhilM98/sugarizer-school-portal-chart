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
helm install <chart-name> .
```
Where `<chart-name>` is the name you want to give to this chart.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
This project is licensed under `Apache v2` License. See [LICENSE](LICENSE) for full license text.

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
