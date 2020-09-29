# GKE Terraform spec

## Requirements

- [docker](https://www.docker.com/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [gcloud ](https://cloud.google.com/sdk/gcloud)
- [jq](https://stedolan.github.io/jq/)

Set the environment then deploy the cluster using the [`ci`](ci.sh) script:

| Environment variable | Description | Default |
|-----------|-------------|---------|
| `DRY_RUN` | Create the plan without applying it | `true` |
| `PROJECT_ID` | Google Cloud Project ID | `""` |
| `NAME` | Google Kubernetes Engine cluster name | `""` |
| `PARENT_DOMAIN` | Google Cloud DNS Parent Domain | `""` |
| `GOOGLE_APPLICATION_CREDENTIALS` | Google Cloud Service Account credentials file | `""` |

> **Note**: [Compute Engine API and Kubernetes Engine API are required for terraform apply to work on this configuration. Enable both APIs for your Google Cloud project before continuing.](https://learn.hashicorp.com/tutorials/terraform/gke#provision-the-gke-cluster)
