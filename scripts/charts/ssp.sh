#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e;

# Load colors
RED='\033[0;31m';
GREEN='\033[0;32m';
YELLOW='\033[0;33m';
BLUE='\033[0;34m';
NC='\033[0m';



printf "\n${YELLOW}Checking for Sugarizer-School-Portal with releasename: ${BLUE}ssp\n${NC}";
helm status ssp >/dev/null 2>&1 || {
    printf >&2 "\n${BLUE}Chart not found. Sugarizer-School-Portal needs to be installed.\n${NC}";

    printf "\n${YELLOW}The setup is paused.\n"${NC};
    printf "\n${YELLOW}Navigate to the repository root and update the chart's ${BLUE}'values.yaml'${YELLOW} file.\n${NC}";
    printf "${YELLOW}Put the ${BLUE}'gcpProjectId'${YELLOW} and ${BLUE}'clouddns'${YELLOW} value in the ${BLUE}'values.yaml'${YELLOW} file.\n${NC}";
    printf "\n${BLUE}gcpProjectId:${YELLOW} The Project ID of the project on Google Cloud Platform.\n${NC}";
    printf "\n${BLUE}clouddns:${YELLOW} Your service account key in base64 format.\n${NC}";
    printf "\n${YELLOW}After editing the ${BLUE}'values.yaml'${YELLOW} file, press Enter to continue setup or press Ctrl+C to exit setup...\n${NC}";
    
    read null;

    printf "\n${BLUE}Installing Sugarizer-School-Portal...\n${NC}";

    helm install ssp ../;
    printf "${GREEN}Sugarizer School Portal Chart has been installed with the release name: ${BLUE}ssp\n${NC}";
}
printf "${GREEN}Finished checking for Sugarizer-School-Portal\n\n${NC}";
