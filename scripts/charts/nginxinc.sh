#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e;

# Load colors
RED='\033[0;31m';
GREEN='\033[0;32m';
YELLOW='\033[0;33m';
BLUE='\033[0;34m';
NC='\033[0m';

printf "${YELLOW}Checking for NGINX Ingress Controller with releasename: ${BLUE}nginx-ingress\n${NC}";
helm status ingress-nginx >/dev/null 2>&1 || {
    printf >&2 "${BLUE}Chart not found. Installing NGINX Ingress Controller...\n${NC}";
    helm repo add nginx-stable https://helm.nginx.com/stable;
    helm repo update;
    helm install ingress-nginx nginx-stable/nginx-ingress -f nginxinc-values.yaml
}
printf "${GREEN}Finished checking for NGINX Ingress Controller\n${NC}";
