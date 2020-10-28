#!/usr/bin/env bash

set -e
set -u

: "${PROJECT_ID:?Missing GKE Project Name}"
: "${REGION:=europe-west1}"
: "${ZONE:=b}"
: "${NAME:?Missing GKE Cluster Name}"
: "${PARENT_DOMAIN:?Missing DNS Parent Domain Name}"
: "${GOOGLE_APPLICATION_CREDENTIALS:?Missing Google Application Credentials}"
: "${DRY_RUN:=true}"

TERRAFORM_VERSION="${TERRAFORM_VERSION:=0.13.3}"
DOMAIN_NAME="${NAME}.${PARENT_DOMAIN}"

# Enable service [cloudresourcemanager.googleapis.com] on project [$PROJECT_ID]
# before running `gcloud config set project "${PROJECT_ID}"`
gcloud auth activate-service-account --key-file="${GOOGLE_APPLICATION_CREDENTIALS}"
gcloud auth list
gcloud config set project "${PROJECT_ID}"
gcloud config set compute/zone "${REGION}-${ZONE}"

# [Compute Engine API and Kubernetes Engine API are required for terraform apply to work on this configuration. Enable both APIs for your Google Cloud project before continuing.](https://learn.hashicorp.com/tutorials/terraform/gke#provision-the-gke-cluster)

# Host requirements: docker, kubectl, gcloud and jq

cat <<EOF > terraform.tfvars
project_id         = "${PROJECT_ID}"
name               = "${NAME}"
region             = "${REGION}"
zones              = ["${REGION}-${ZONE}"]
parent_domain      = "${PARENT_DOMAIN}"
EOF

docker run --rm -t \
    -u 1000 \
    --name terraform \
    -v ${PWD}:/workspace/source \
    -w /workspace/source \
    -e PROJECT=${PROJECT_ID} \
    -e NAME=${NAME} \
    -e PARENT_DOMAIN=${PARENT_DOMAIN} \
    build.yields.io/terraform init

docker run --rm -t \
    -u 1000 \
    --name terraform \
    -v ${GOOGLE_APPLICATION_CREDENTIALS}:/account.json \
    -e GOOGLE_APPLICATION_CREDENTIALS=/account.json \
    -v ${PWD}:/workspace/source \
    -w /workspace/source \
    build.yields.io/terraform plan --var-file terraform.tfvars -no-color

docker run --rm -t \
    -u 1000 \
    --name terraform \
    -v ${GOOGLE_APPLICATION_CREDENTIALS}:/account.json \
    -e GOOGLE_APPLICATION_CREDENTIALS=/account.json \
    -v ${PWD}:/workspace/source \
    -w /workspace/source \
    build.yields.io/terraform plan --var-file terraform.tfvars -no-color -out=tfplan.out

docker run --rm -t \
    -u 1000 \
    --name terraform \
    -v ${PWD}:/workspace/source \
    -w /workspace/source \
    build.yields.io/terraform show -json tfplan.out |jq

[ ! "${DRY_RUN}" ] || docker run --rm -t \
    -v ${PWD}:/workspace/source \
    -v ${GOOGLE_APPLICATION_CREDENTIALS}:/account.json \
    -e GOOGLE_APPLICATION_CREDENTIALS=/account.json \
    -w /workspace/source \
    --entrypoint terraform \
    build.yields.io/terraform apply -auto-approve --var-file terraform.tfvars
