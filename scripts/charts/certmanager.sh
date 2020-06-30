#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e;

# Load colors
RED='\033[0;31m';
GREEN='\033[0;32m';
YELLOW='\033[0;33m';
BLUE='\033[0;34m';
NC='\033[0m';

printf "${YELLOW}Checking for Cert-Manager with releasename: ${BLUE}cert-manager\n${NC}";
helm status cert-manager --namespace=cert-manager >/dev/null 2>&1 || {
    printf >&2 "${BLUE}Chart not found. Installing Cert-Manager...\n${NC}";
    kubectl create namespace cert-manager;
    helm repo add jetstack https://charts.jetstack.io;
    helm repo update;
    helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v0.15.1 --set installCRDs=true;
}
printf "${GREEN}Finished checking for Cert-Manager\n${NC}";
