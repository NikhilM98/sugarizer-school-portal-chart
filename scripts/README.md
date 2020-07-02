# Sugarizer School Portal Environment Setup

Setup Script for Sugarizer School Portal Environment.    

## Instructions

Navigate into scripts directory and run `sh setup.sh` from your terminal to set-up the environment for Sugarizer School Portal on the cluster.

```bash
# Navigate into scripts directory
cd scripts

# Execute setup script
sh setup.sh
```

After setting up the environment, point the Address (`A`) Record of your Cloud DNS zone to the Cluster IP of the NGINX Ingress Controller.

After that, to install Sugarizer School Portal chart, navigate to the repository root, edit the chart `values.yaml` and run `helm install`.

```bash
# Navigate into the Sugarizer School Portal chart directory and run:
helm install <chart-name> .
```
Where `<chart-name>` is the name you want to give to this chart.


## Usage

The setup checks and installs these prerequisites if they're not already present:
- [GCloud](https://cloud.google.com/sdk)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Git](https://git-scm.com/)
- [Curl](https://curl.haxx.se/) - If required
- [GnuPG](https://gnupg.org/) - If required
- [Helm 3](https://helm.sh/)

It then checks and installs the required Helm charts:
- [MongoDB Replicaset](https://github.com/helm/charts/tree/master/stable/mongodb-replicaset) as `mymongodb` in `default` namespace.
- [Kubernetes-Reflector](https://github.com/emberstack/kubernetes-reflector) as `reflector` in `default` namespace.
- [NGINX Ingress Controller](https://github.com/nginxinc/kubernetes-ingress/) as `ingress-nginx` in `default` namespace.
- [Cert-Manager](https://cert-manager.io/docs/) as `cert-manager` in `cert-manager` namespace.
