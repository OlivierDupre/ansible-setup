#!/bin/bash

gcloud kms keyrings create perso  --location global
gcloud kms keys create perso --location global --keyring perso  --purpose encryption

gcloud compute disks create disk1 --image-project ubuntu-os-cloud --image-family ubuntu-1904 --zone ${GCP_ZONE} #--size 20

gcloud compute images create nested-ubuntu-image \
  --source-disk disk1 --source-disk-zone ${GCP_ZONE} \
  --licenses "https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx"

gcloud compute instances create ${INSTANCE_NAME}
              --zone ${GCP_ZONE} \
              --min-cpu-platform "Intel Skylake" \
              --image nested-ubuntu-image \
              --description "Personal development environment" \
              --boot-disk-size 20GB \
              --boot-disk-type pd-ssd \
              --metadata enable-oslogin=FALSE
              --machine-type n1-standard-4  # 4 CPU + 16 Gb RAM

gcloud compute disks snapshot ${INSTANCE_NAME} --project=${PROJECT_NAME} --description=Kata-container,\ Docker\ \&\ gVisor\ installed.$'\n'microk8s,\ gcloud,\ aws-cli,\ az-cli\ installed. --labels=project=perso,env=dev --snapshot-names=initial-snapshot --zone=${GCP_ZONE} --storage-location=europe-west1