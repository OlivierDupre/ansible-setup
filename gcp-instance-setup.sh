#!/bin/bash

gcloud kms keyrings create perso  --location global
gcloud kms keys create perso --location global --keyring perso  --purpose encryption


gcloud compute disks create disk1 --image-project ubuntu-os-cloud 	 --image-family ubuntu-1904 --zone europe-west1-b #--size 20
gcloud compute images create nested-ubuntu-image \
  --source-disk disk1 --source-disk-zone europe-west1-b \
  --licenses "https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx"
gcloud compute instances create dev-env --zone europe-west1-b \
              --min-cpu-platform "Intel Skylake" \
              --image nested-ubuntu-image \
              --description "Personal development environment" \
              --boot-disk-size 20GB \
              --boot-disk-type pd-ssd \
              --machine-type n1-standard-4  # 4 CPU + 16 Gb RAM
