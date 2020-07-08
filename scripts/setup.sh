#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Load colors
RED='\033[0;31m';
GREEN='\033[0;32m';
YELLOW='\033[0;33m';
BLUE='\033[0;34m';
NC='\033[0m';

# Print Intro Message
printf "\n${GREEN}Sugarizer School Portal Setup${NC}\n\n"

# Check for dependencies
sh prerequisite.sh

# Check for MongoDB-Replicaset
sh charts/mongodb.sh

# Check for Kubernetes-Reflector
sh charts/reflector.sh

# Check for NGINX Ingress Controller
sh charts/nginxinc.sh

# Check for Cert-Manager
sh charts/certmanager.sh

printf "${GREEN}Finished setting up the Sugarizer School Portal Environment${NC}\n"

# Check for Sugarizer School Portal
sh charts/ssp.sh

printf "${GREEN}Finished setting up the Kubernetes cluster${NC}\n"

printf "\n${YELLOW}Note: Point the Address ${BLUE}('A')${YELLOW} Record of your Cloud DNS zone to the Cluster IP of the NGINX Ingress Controller.${NC}\n\n"
