#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e;

# Load colors
RED='\033[0;31m';
GREEN='\033[0;32m';
YELLOW='\033[0;33m';
BLUE='\033[0;34m';
NC='\033[0m';

printf "${YELLOW}Checking for Kubernetes-Reflector with releasename: ${BLUE}reflector\n${NC}";
helm status reflector >/dev/null 2>&1 || {
    printf >&2 "${BLUE}Chart not found. Installing Kubernetes-Reflector...\n${NC}";
    helm repo add emberstack https://emberstack.github.io/helm-charts;
    helm repo update;
    helm install reflector emberstack/reflector;
}
printf "${GREEN}Finished checking for Kubernetes-Reflector\n${NC}";
