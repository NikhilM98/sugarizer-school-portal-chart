# Sugarizer School Portal Setup

A complete Setup Script for Sugarizer School Portal dependencies, environment, and the helm chart.    

## Instructions

Navigate into scripts directory and run `sh setup.sh` from your terminal to set-up the environment for Sugarizer School Portal on the cluster.

```bash
# Navigate into scripts directory
cd scripts

# Execute setup script
sh setup.sh
```

After setting up the environment, the setup will pause.
Navigate to the repository root, update the chart `values.yaml` file.
Put the `gcpProjectId` and `clouddns` value in the `values.yaml` file.

**gcpProjectId:** The Project ID of the project on Google Cloud Platform.

**clouddns:** Your service account key in base64 format.

Press `Enter` to proceed once you have edited the chart values.

The Sugarizer School Portal Chart will be installed with the release name `ssp`.

Note: Point the Address (`A`) Record of your Cloud DNS zone to the Cluster IP of the NGINX Ingress Controller.

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

It then checks and installs [Sugarizer School Portal Helm Chart](https://github.com/NikhilM98/sugarizer-school-portal-chart) if everything is fine.
