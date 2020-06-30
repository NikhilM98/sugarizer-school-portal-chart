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
printf "${YELLOW}Checking for dependencies...\n${NC}"

gcloud_instructions() {
    printf ${YELLOW}
    printf "\nPlease run:\n    $ gcloud auth login\nto obtain new credentials.\n\nIf you have already logged in with a different account:\n    $ gcloud config set account ACCOUNT\nto select an already authenticated account to use.\n";
    printf "\nAfter that, to connect with your cluster, please run:\n    $ gcloud container clusters get-credentials <custer_name> --zone <zone_name> --project <project_name>\n\n";
    printf ${NC}
}

# Check for dependencies
command -v gcloud >/dev/null 2>&1 || {
    printf >&2 "${BLUE}Installing GCloud...\n${NC}";
    apt-get update && apt-get install -y gnupg2;
    command -v curl >/dev/null 2>&1 || {
        printf >&2 "${BLUE}Installing Curl...\n${NC}";
        apt -y install curl;
    }
    printf "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk -y;
    printf "${RED}\nSetup Aborted |${RED}Login to GCloud account to continue.\n${NC}"
    gcloud_instructions
    exit 1;
}
command -v kubectl >/dev/null 2>&1 || {
    printf >&2 "${BLUE}Installing kubectl using gcloud components...\n${NC}";
    apt update && apt-get install kubectl;
}
command -v helm >/dev/null 2>&1 || {
    printf >&2 "${BLUE}Installing Helm 3...\n${NC}";
    command -v curl >/dev/null 2>&1 || {
        printf >&2 "${BLUE}Installing Curl...\n${NC}";
        apt update && apt -y install curl;
    }
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash;
}
command -v git >/dev/null 2>&1 || {
    printf >&2 "${BLUE}Installing Git...\n${NC}";
    apt update && apt -y install git;
}

# Check if the cluster is accessible
kubectl get pods >/dev/null 2>&1 || {
    printf >&2 "${RED}\nError: You're not connected with the cluster.\n${NC}"
    gcloud_instructions
    exit 1;
}

# Print Exit Message
printf "${GREEN}Finished checking for dependencies\n${NC}"
